package com.harunichi.board.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.harunichi.board.service.BoardService;
import com.harunichi.board.vo.BoardLikeVo;
import com.harunichi.board.vo.BoardVo;
import com.harunichi.board.vo.ReplyVo;
import com.harunichi.member.service.MemberService;
import com.harunichi.member.vo.MemberVo;

import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnails;

@Slf4j
@Controller("boardController")
@RequestMapping("/board")
public class BoardControllerImpl implements BoardController {

	// private static final String IMAGE_REPO = "c:\\spring\\image_repo";

	// 에러페이지 만들기
	// 스마트에디터 적용
	// 닉네임 기준 MemberVo 매핑하기

	@Autowired
	private BoardService boardService;

	@Autowired
	private MemberService memberService;

	@Autowired
	private ServletContext servletContext; // 톰캣과 대화할 수 있는 메서드를 제공

	// 게시글 목록
	@Override
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public ModelAndView boardList(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView("/board/list");

		try {
			// 로그인한 사용자 정보 가져오기
			HttpSession session = request.getSession();
			MemberVo loginUser = (MemberVo) session.getAttribute("member");

			List<BoardVo> boardList = boardService.selectBoardList();
			Map<String, MemberVo> memberMap = new HashMap<>(); // 닉네임 → MemberVo 캐싱

			if (boardList != null && !boardList.isEmpty()) {
				for (BoardVo board : boardList) {
					int boardId = board.getBoardId();
					// boardService의 getReplyCountByBoardId 메서드를 호출하여 실제 댓글 수를 가져옴
					int actualReplyCount = boardService.getReplyCountByBoardId(boardId);
					board.setBoardRe(actualReplyCount);
					// 좋아요 수 업데이트 (이미 DB에서 가져온 값이 있을 수 있지만, 최신 상태 보장)
					int likeCount = boardService.getBoardLikeCount(boardId);
					board.setBoardLike(likeCount);

					// 로그인한 사용자가 있는 경우 좋아요 상태 확인
					if (loginUser != null) {
						BoardLikeVo likeVo = new BoardLikeVo();
						likeVo.setBoardLikeUser(loginUser.getId());
						likeVo.setBoardLikePost(boardId);

						boolean isLiked = boardService.checkBoardLikeStatus(likeVo);

						// 각 게시글의 좋아요 상태를 Map에 저장
						if (mav.getModel().get("likedPosts") == null) {
							mav.addObject("likedPosts", new HashMap<Integer, Boolean>());
						}
						((Map<Integer, Boolean>) mav.getModel().get("likedPosts")).put(boardId, isLiked);
					}

					// 작성자 프로필 이미지 설정
					String writerId = board.getBoardWriterId();
					if (writerId != null && !writerId.isEmpty()) {
						MemberVo writerInfo = memberMap.get(writerId);
						if (writerInfo == null) {
							writerInfo = memberService.selectMemberById(writerId);
							if (writerInfo != null) {
								memberMap.put(writerId, writerInfo);
							}
						}
						if (writerInfo != null) {
							board.setBoardWriterImg(writerInfo.getProfileImg());
						}
					}
					
					// 줄바꿈 문자 -> <br />로 변환
					if (board.getBoardCont() != null) {
						String convertedContent = board.getBoardCont().replaceAll("(\r\n|\r|\n)", "<br />");
						board.setBoardCont(convertedContent);
					}
				}
			}

			// 인기 게시글 TOP 5 추가
			List<BoardVo> top5List = boardService.getTop5BoardsByViews();
			mav.addObject("top5List", top5List);

			mav.addObject("boardList", boardList);

		} catch (Exception e) {
			log.error("게시글 목록 조회 및 댓글 수 업데이트 중 오류 발생", e);
			mav.addObject("msg", "게시글 목록을 불러오는 중 오류가 발생했습니다.");
		}
		return mav;
	}

	// 게시글 등록 폼 요청
	@RequestMapping(value = "/postForm", method = RequestMethod.GET)
	public String boardForm() throws Exception {
		return "/board/postForm";
	}

	// 게시글 등록
	@Override
	@RequestMapping(value = "/post", method = RequestMethod.POST)
	public ModelAndView boardPost(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("imageFiles") List<MultipartFile> imageFiles) {

		ModelAndView mav = new ModelAndView();

		try {
			// 1. 파라미터 받기 (작성자, 내용 등)
			// String boardWriter = request.getParameter("boardWriter");
			String boardCont = request.getParameter("boardCont");
			String boardCate = request.getParameter("boardCate");

			// 2. BoardVo 객체 생성 및 데이터 설정
			BoardVo boardVo = new BoardVo();

			// boardVo.setBoardWriter(boardWriter);
			HttpSession session = request.getSession();
			MemberVo loginUser = (MemberVo) session.getAttribute("member"); 

			if (loginUser != null) {

				boardVo.setBoardWriter(loginUser.getNick());
				boardVo.setBoardWriterId(loginUser.getId());
				 // 사용자의 프로필 이미지 설정 추가
	            boardVo.setBoardWriterImg(loginUser.getProfileImg());

			} else {
				log.warn(">> 게시글 작성 실패: 로그인되지 않은 사용자 요청");
				mav.addObject("msg", "게시글을 작성하려면 로그인이 필요합니다.");
				mav.setViewName("redirect:/member/loginpage.do");
				return mav;
			}

			boardVo.setBoardCate(boardCate);
			boardVo.setBoardCont(boardCont);

			// boardDate에 현재 시간 설정
			boardVo.setBoardDate(new Timestamp(System.currentTimeMillis())); // 현재 시간 설정

			// 3. 파일 업로드 처리 및 파일명 설정
			List<String> fileNames = uploadFiles(servletContext, imageFiles);
			if (fileNames != null && !fileNames.isEmpty()) {
				if (fileNames.size() > 0)
					boardVo.setBoardImg1(fileNames.get(0));
				if (fileNames.size() > 1)
					boardVo.setBoardImg2(fileNames.get(1));
				if (fileNames.size() > 2)
					boardVo.setBoardImg3(fileNames.get(2));
				if (fileNames.size() > 3)
					boardVo.setBoardImg4(fileNames.get(3));
			}

			// 4. BoardService를 통해 게시글 등록
			boardService.insertBoard(boardVo);

			// 5. 결과 설정 및 뷰 반환
			mav.setViewName("redirect:/board/list");

		} catch (Exception e) {
			log.error("게시글 등록 중 오류 발생", e);
			mav.addObject("msg", "게시글 등록 중 오류가 발생했습니다.");
			mav.setViewName("/board/errorPage");
		}

		return mav;
	}

	// 게시글 상세 요청 URL: /board/view?boardId=숫자
	@Override
	@RequestMapping(value = "/view", method = RequestMethod.GET)
	public ModelAndView viewBoard(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("boardId") int boardId) throws Exception {

		ModelAndView mav = new ModelAndView("/board/view");

		try {

			BoardVo boardVo = boardService.getBoardById(boardId);

			if (boardVo != null) {

				// 게시글의 댓글 개수를 별도로 조회
				int replyCount = boardService.getReplyCountByBoardId(boardId);
				// BoardVo 객체에 댓글 개수 설정
				boardVo.setBoardRe(replyCount);

				// 해당 게시글의 댓글 목록을 불러와서 mav에 추가
				List<ReplyVo> replyList = boardService.getRepliesByBoardId(boardId);

				// 댓글 작성자 프로필 이미지
				Map<String, MemberVo> memberCache = new HashMap<>();
				for (ReplyVo reply : replyList) {
					String replyWriterId = reply.getReplyWriterId(); // 아이디로 바꿈
					if (replyWriterId != null && !replyWriterId.isEmpty()) {
						if (!memberCache.containsKey(replyWriterId)) {
							MemberVo memberInfo = memberService.selectMemberById(replyWriterId);
							memberCache.put(replyWriterId, memberInfo);
						}
						MemberVo memberInfo = memberCache.get(replyWriterId);
						if (memberInfo != null) {
							reply.setReplyWriterImg(memberInfo.getProfileImg());
						}
					}
				}

				mav.addObject("replyList", replyList);

				// 작성자 프로필 이미지
				String writerId = boardVo.getBoardWriterId();
				if (writerId != null && !writerId.isEmpty()) {
					MemberVo writerInfo = memberService.selectMemberById(writerId);
					if (writerInfo != null) {
						boardVo.setBoardWriterImg(writerInfo.getProfileImg());
					}
				}

				// 로그인한 사용자 정보 가져오기
				HttpSession session = request.getSession();
				MemberVo loginUser = (MemberVo) session.getAttribute("member");

				if (boardVo.getBoardCont() != null) {
					String convertedContent = boardVo.getBoardCont().replaceAll("(\r\n|\r|\n)", "<br />");
					boardVo.setBoardCont(convertedContent);
				}

				// 좋아요 상태 확인
				boolean isLiked = false;
				if (loginUser != null) {
					BoardLikeVo likeVo = new BoardLikeVo();
					likeVo.setBoardLikeUser(loginUser.getId());
					likeVo.setBoardLikePost(boardId);

					isLiked = boardService.checkBoardLikeStatus(likeVo);
					mav.addObject("isLiked", isLiked);
				}

				// 게시글 정보 (댓글 개수 포함)를 mav에 추가
				mav.addObject("board", boardVo); // boardRe

				// 좋아요 수 조회
				int likeCount = boardService.getBoardLikeCount(boardId);
				mav.addObject("likeCount", likeCount);

				// 인기 게시글 TOP 5 추가
				List<BoardVo> top5List = boardService.getTop5BoardsByViews();
				mav.addObject("top5List", top5List);

			} else {
				log.warn(">>조회할 게시글(ID:{})을 찾을 수 없습니다.", boardId);
				mav.setViewName("redirect:/board/list");
				mav.addObject("msg", "notfound");
			}
		} catch (Exception e) {
			log.error("게시글 상세 조회 중 오류 발생, boardId:{}", boardId, e);
			mav.addObject("msg", "게시글 상세 조회 중 오류가 발생했습니다.");
			mav.setViewName("/board/errorPage");
		}
		log.info(">>BoardControllerImpl-viewBoard() 호출 종료");
		return mav;
	}

	// 게시글 수정 폼 요청
	@RequestMapping(value = "/editForm", method = RequestMethod.GET)
	public ModelAndView editBoardForm(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("boardId") int boardId) throws Exception {

		ModelAndView mav = new ModelAndView("/board/editForm");

		try {
			// 조회수 증가 로직이 없는 서비스 메소드
			BoardVo boardVo = boardService.getBoardByIdWithoutIncrement(boardId);

			if (boardVo != null) {
				log.info(">> 게시글 정보 가져오기 성공! boardId: {}", boardVo.getBoardId());
				mav.addObject("board", boardVo); // 모델에 게시글 정보 추가
			} else {
				log.warn(">> 해당 boardId의 게시글이 없습니다: {}", boardId);
				mav.addObject("msg", "게시글을 찾을 수 없습니다.");
				// mav.setViewName("/board/errorPage");
				mav.setViewName("redirect:/board/list");
			}

		} catch (Exception e) {
			log.error(">> 게시글 수정 폼 로딩 중 예외 발생, boardId: {}", boardId, e);
			mav.addObject("msg", "게시글 수정 폼을 불러오는 중 시스템 오류가 발생했습니다.");
			// mav.setViewName("/board/errorPage");
			mav.setViewName("redirect:/board/list");
		}
		log.info(">> BoardControllerImpl - editBoardForm() 호출 종료");
		return mav;
	}

	// 파일 삭제 헬퍼 메소드 (ServiceImpl에서 이동)
	private void deleteFile(String fileName, ServletContext context) {
		if (fileName != null && !fileName.isEmpty()) {
			String uploadPath = context.getRealPath("/resources/images/board"); // 실제 파일 저장 경로 가져오기
			File fileToDelete = new File(uploadPath, fileName);
			if (fileToDelete.exists()) {
				if (fileToDelete.delete()) {
					log.info(">>파일 삭제 성공:{}", fileName);
				} else {
					log.warn(">>파일 삭제 실패:{}", fileName);
				}
			} else {
				log.warn(">>삭제하려는 파일이 존재하지 않습니다:{}", fileName);
			}
		} else {
			log.warn(">>파일 삭제 시도 실패: 파일명이 유효하지 않습니다.");
		}
	}

	// 게시글 수정
	@Override
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public ModelAndView updateBoard(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "imageFiles", required = false) List<MultipartFile> imageFiles, // 새로 업로드할 파일 리스트
			@RequestParam(value = "deleteIndices", required = false) List<Integer> deleteIndices // 삭제할 기존 이미지의 순서(1, 2,
																									// 3, 4) 리스트
	) {
		ModelAndView mav = new ModelAndView();
		log.info(">>BoardControllerImpl-updateBoard() 호출 시작");
		// 삭제 요청된 파일들의 실제 파일명을 저장할 리스트
		List<String> filesToDeleteFromSystem = new ArrayList<>();
		// 업로드되었으나 최종 목록에 포함되지 않은 파일 목록
		List<String> uploadedButNotAdded = new ArrayList<>();

		try {
			// 1. 파라미터 받기
			int boardId = Integer.parseInt(request.getParameter("boardId"));
			String boardCont = request.getParameter("boardCont");
			String boardCate = request.getParameter("boardCate");
			log.info(">>수정을 위한 boardId:{}", boardId);
			log.info(">>수정 내용:{}, 카테고리:{}", boardCont, boardCate);
			log.info(">>삭제 요청된 이미지 순서:{}", deleteIndices);

			// 2. 기존 게시글 정보 조회 (파일 이름 확인용)
			BoardVo existingBoard = boardService.getBoardByIdWithoutIncrement(boardId);
			if (existingBoard == null) {
				log.warn(">>수정하려는 게시글(ID:{})을 찾을 수 없습니다.", boardId);
				mav.addObject("msg", "수정하려는 게시글을 찾을 수 없습니다.");
				mav.setViewName("redirect:/board/list");
				return mav;
			}
			log.info(">>기존 게시글 정보 조회 완료.");

			// 3. 삭제 요청된 기존 이미지 처리
			// 삭제 요청이 들어온 이미지 순서에 해당하는 필드를 null로 설정하고 실제 삭제할 파일 목록에 추가
			if (deleteIndices != null && !deleteIndices.isEmpty()) {
				log.info(">>삭제 요청된 이미지 처리 시작");
				// 기존 이미지 파일명 리스트를 임시로 만듬
				List<String> currentImageNames = new ArrayList<>();
				currentImageNames.add(existingBoard.getBoardImg1()); // 인덱스 0 (순서 1)
				currentImageNames.add(existingBoard.getBoardImg2()); // 인덱스 1 (순서 2)
				currentImageNames.add(existingBoard.getBoardImg3()); // 인덱스 2 (순서 3)
				currentImageNames.add(existingBoard.getBoardImg4()); // 인덱스 3 (순서 4)

				for (Integer index : deleteIndices) {
					// 순서는 1부터 시작하므로 인덱스는 순서-1
					int listIndex = index - 1;
					if (listIndex >= 0 && listIndex < currentImageNames.size()) {
						String fileNameToDelete = currentImageNames.get(listIndex);
						if (fileNameToDelete != null && !fileNameToDelete.isEmpty()) {
							log.info(">>기존 이미지 {}(파일명:{}) 삭제 요청 감지. DB 필드를 null로 설정.", index, fileNameToDelete);
							// 해당 순서의 이미지 필드를 null로 설정 (DB 업데이트 시 반영)
							switch (index) {
							case 1:
								existingBoard.setBoardImg1(null);
								break;
							case 2:
								existingBoard.setBoardImg2(null);
								break;
							case 3:
								existingBoard.setBoardImg3(null);
								break;
							case 4:
								existingBoard.setBoardImg4(null);
								break;
							}
							// 실제 파일 시스템에서 삭제할 파일 목록에 추가
							filesToDeleteFromSystem.add(fileNameToDelete);
						} else {
							log.warn(">>삭제 요청된 순서 {}에 해당하는 기존 이미지가 없습니다.", index);
						}
					} else {
						log.warn(">>유효하지 않은 삭제 요청 순서:{}", index);
					}
				}
			} else {
				log.info(">>삭제 요청된 이미지가 없습니다. 기존 이미지를 유지합니다.");
			}

			// 4. 새로운 이미지 파일 업로드 처리
			List<String> newFileNames = new ArrayList<>();
			boolean isNewFileUploaded = (imageFiles != null && !imageFiles.isEmpty()
					&& imageFiles.get(0).getSize() > 0);
			if (isNewFileUploaded) {
				log.info(">>새로운 이미지 파일이 감지되었습니다.");
				newFileNames = uploadFiles(servletContext, imageFiles); // 새로운 파일 업로드 로직 호출
				log.info(">>업로드된 새 파일명:{}", newFileNames);
			} else {
				log.info(">>새로운 이미지 파일이 첨부되지 않았습니다.");
			}

			// 5. 최종 이미지 목록 구성 (삭제되지 않고 남은 기존 이미지 + 새로 업로드된 이미지 추가, 최대 4개 제한)
			List<String> finalImageNames = new ArrayList<>();
			// 삭제되지 않고 남은 기존 이미지 추가 (existingBoard 객체는 이미 삭제 요청된 필드가 null로 설정되어 있음)
			if (existingBoard.getBoardImg1() != null)
				finalImageNames.add(existingBoard.getBoardImg1());
			if (existingBoard.getBoardImg2() != null)
				finalImageNames.add(existingBoard.getBoardImg2());
			if (existingBoard.getBoardImg3() != null)
				finalImageNames.add(existingBoard.getBoardImg3());
			if (existingBoard.getBoardImg4() != null)
				finalImageNames.add(existingBoard.getBoardImg4());
			log.info(">>삭제 처리 후 남은 기존 이미지:{}", finalImageNames);

			// 새로 업로드된 이미지 추가 (최대 4개까지)
			if (newFileNames != null) {
				for (String newName : newFileNames) {
					if (finalImageNames.size() < 4) { // 최대 개수(4개) 확인
						finalImageNames.add(newName);
						log.info(">>새 이미지 '{}'를 최종 목록에 추가합니다.", newName);
					} else {
						log.warn(">>이미지 최대 개수(4개) 초과로 새로운 파일 '{}'은 추가되지 않았습니다.", newName);
						uploadedButNotAdded.add(newName); // 추가되지 못한 파일 목록에 추가
					}
				}
			}
			log.info(">>최종 이미지 목록:{}", finalImageNames);
			log.info(">>업로드되었으나 추가되지 못한 파일 목록:{}", uploadedButNotAdded);

			// 6. BoardVo 객체에 최종 데이터 설정
			// existingBoard 객체에 수정 내용과 최종 이미지 목록을 설정
			existingBoard.setBoardCont(boardCont);
			existingBoard.setBoardCate(boardCate);
			existingBoard.setBoardModDate(new Timestamp(System.currentTimeMillis())); // 수정 시간 설정

			// 이미지 필드를 모두 초기화하고 최종 목록으로 다시 설정함
			existingBoard.setBoardImg1(null);
			existingBoard.setBoardImg2(null);
			existingBoard.setBoardImg3(null);
			existingBoard.setBoardImg4(null);

			if (finalImageNames.size() > 0)
				existingBoard.setBoardImg1(finalImageNames.get(0));
			if (finalImageNames.size() > 1)
				existingBoard.setBoardImg2(finalImageNames.get(1));
			if (finalImageNames.size() > 2)
				existingBoard.setBoardImg3(finalImageNames.get(2));
			if (finalImageNames.size() > 3)
				existingBoard.setBoardImg4(finalImageNames.get(3));

			// 7. BoardService를 통해 게시글 업데이트 (DB 저장)
			log.info(">>게시글 DB 업데이트를 위해 Service 호출");
			boardService.updateBoard(existingBoard);
			log.info(">>BoardService.updateBoard() 호출 완료");

			// 8. DB 업데이트 성공 시 실제 파일 시스템에서 파일 삭제
			log.info(">>DB 업데이트 성공. 실제 파일 시스템 삭제 시도.");
			// 삭제 요청된 기존 파일 삭제
			if (!filesToDeleteFromSystem.isEmpty()) {
				log.info(">>삭제 요청된 기존 파일 {}개 삭제 시도.", filesToDeleteFromSystem.size());
				for (String fileName : filesToDeleteFromSystem) {
					try {
						// deleteFile 헬퍼 메소드 호출 시 파라미터 순서 수정
						deleteFile(fileName, servletContext);
					} catch (Exception e) {
						log.error("기존 이미지 파일 삭제 중 오류 발생 (DB 업데이트는 완료됨): {}", fileName, e);
						// 파일 삭제 실패는 로그만 남기고 계속 진행
					}
				}
				log.info(">>삭제 요청된 기존 파일 삭제 시도 완료.");
			} else {
				log.info(">>삭제 요청된 기존 파일이 없습니다.");
			}

			// 업로드되었지만 최종 목록에 포함되지 않은 파일 삭제 (최대 개수 초과 등)
			if (!uploadedButNotAdded.isEmpty()) {
				log.info(">>업로드되었으나 사용되지 않은 파일 {}개 삭제 시도.", uploadedButNotAdded.size());
				for (String fileName : uploadedButNotAdded) {
					try {
						// deleteFile 헬퍼 메소드 호출 시 파라미터 순서 수정
						deleteFile(fileName, servletContext);
					} catch (Exception e) {
						log.error("업로드되었으나 사용되지 않은 파일 삭제 중 오류 발생: {}", fileName, e);
						// 파일 삭제 실패는 로그만 남기고 계속 진행
					}
				}
				log.info(">>업로드되었으나 사용되지 않은 파일 삭제 시도 완료.");
			} else {
				log.info(">>업로드되었으나 사용되지 않은 파일이 없습니다.");
			}

			log.info(">>파일 시스템 삭제 시도 완료.");

			// 9. 결과 설정 및 뷰 반환
			mav.setViewName("redirect:/board/view?boardId=" + boardId);

		} catch (NumberFormatException e) { // boardId 파라미터가 숫자가 아닐 경우 발생
			log.error(">>게시글 ID 파싱 오류 발생:{}", request.getParameter("boardId"), e);
			mav.addObject("msg", "잘못된 게시글 정보입니다.");
			// mav.setViewName("/board/errorPage"); // 400 Bad Request 에러 페이지
			mav.setViewName("redirect:/board/list"); // 목록으로 리다이렉트
		} catch (Exception e) {
			log.error(">>게시글 수정 처리 중 예외 발생, boardId:{}", request.getParameter("boardId"), e);
			mav.addObject("msg", "게시글 수정 중 오류가 발생했습니다.");
			// mav.setViewName("/board/errorPage"); // 500 Internal Server Error 에러 페이지
			mav.setViewName("redirect:/board/list"); // 목록으로 리다이렉트
		}
		log.info(">>BoardControllerImpl-updateBoard() 호출 종료");
		return mav;
	}

	// 파일 업로드 처리 메소드 (ServletContext 파라미터 추가)
	private List<String> uploadFiles(ServletContext context, List<MultipartFile> imageFiles) throws Exception {
		List<String> fileNames = new ArrayList<>();

		String realPath = context.getRealPath("/");

		// File.separator를 사용하여 OS에 맞는 경로 구분자를 사용
		String uploadPath = realPath + "resources" + File.separator + "images" + File.separator + "board";

		File repoDir = new File(uploadPath);

		if (!repoDir.exists()) {
			log.info("이미지 저장 폴더가 존재하지 않습니다. 폴더를 생성합니다.");
			try {
				repoDir.mkdirs(); // 폴더 생성 시도
				log.info("이미지 저장 폴더 생성 성공: " + uploadPath);
			} catch (Exception e) {
				log.error("이미지 저장 폴더 생성 실패: " + uploadPath, e);
				return fileNames;
			}
		} else {
			log.info("이미지 저장 폴더가 이미 존재합니다: " + uploadPath);
		}

		// imageFiles가 null이거나 비어있으면 더 이상 진행하지 않고 빈 리스트를 반환
		if (imageFiles == null || imageFiles.isEmpty()) {
			log.info("업로드할 이미지가 없습니다.");
			return fileNames;
		}

		// 파일 업로드 로직
		for (MultipartFile imageFile : imageFiles) {
			if (imageFile.isEmpty()) {
				log.warn("첨부 파일이 비어있습니다. 파일 업로드를 건너뜁니다.");
				continue; // 다음 파일로 진행
			}

			// 파일 타입 검사 (이미지 파일만 허용)
			String contentType = imageFile.getContentType();
			if (contentType == null || !contentType.startsWith("image/")) {
				log.warn("유효하지 않은 파일 형식: {}", imageFile.getOriginalFilename());
				continue;
			}

			String originalFileName = imageFile.getOriginalFilename();
			String extension = "";
			int lastDotIndex = originalFileName.lastIndexOf(".");
			if (lastDotIndex > 0) {
				extension = originalFileName.substring(lastDotIndex);
			}
			// 파일명 중복 방지를 위해 UUID 사용
			String fileName = UUID.randomUUID().toString() + extension;
			File targetFile = new File(repoDir, fileName); // 저장할 파일 객체 생성

			try {
				// 파일 저장 시도
				imageFile.transferTo(targetFile); // 파일 저장
				fileNames.add(fileName); // 파일 이름 리스트에 추가
				log.info("파일 업로드 성공: {} -> {}", originalFileName, fileName);
			} catch (IOException e) {
				log.error("파일 업로드 실패: {}", originalFileName, e);
			} catch (Exception e) {
				log.error("예상치 못한 오류 발생: {}", originalFileName, e);
			}
		}
		// 최종적으로 업로드된 파일 이름 리스트를 반환
		return fileNames;
	}

	// 게시글 삭제 처리
	@Override
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public ModelAndView deleteBoard(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("boardId") int boardId) throws Exception {

		log.info(">>BoardControllerImpl-deleteBoard() 호출 시작, boardId:{}", boardId);

		BoardVo boardToDelete = null;
		int dbDeleteResult = 0; // DB 삭제 결과
		ModelAndView mav = new ModelAndView(); // ModelAndView 객체 미리 생성

		try {
			// 1. Service를 통해 삭제할 게시글 정보 (파일 이름 포함) 조회
			log.info(">>게시글 정보 조회를 위해 Service 호출 (getBoardByIdWithoutIncrement), boardId:{}", boardId);
			boardToDelete = boardService.getBoardByIdWithoutIncrement(boardId);

			if (boardToDelete == null) {
				log.warn(">>삭제할 게시글(ID:{})을 찾을 수 없습니다. 삭제를 중단합니다.", boardId);
				// 게시글이 없으면 목록 페이지로 리다이렉트 또는 에러 처리
				mav.setViewName("redirect:/board/list");
				mav.addObject("msg", "notfound");
				return mav;
			}

			// 2. Service를 통해 데이터베이스에서 게시글, 댓글, 좋아요 데이터 삭제
			log.info(">>데이터베이스 삭제를 위해 Service 호출 (deleteBoardData), boardId:{}", boardId);
			dbDeleteResult = boardService.deleteBoardData(boardId);

			// 3. 데이터베이스 삭제 성공 시 실제 파일 시스템에서 이미지 파일 삭제
			if (dbDeleteResult > 0) { // 게시글 레코드가 1개 이상 삭제되었다면 (DB 삭제 성공)
				log.info(">>데이터베이스 삭제 성공 ({} 행 삭제). 파일 삭제 시도.", dbDeleteResult);
				// 파일 삭제는 DB 트랜잭션과 별개로 Controller에서 처리
				try {
					deleteFile(boardToDelete.getBoardImg1(), servletContext);
					deleteFile(boardToDelete.getBoardImg2(), servletContext);
					deleteFile(boardToDelete.getBoardImg3(), servletContext);
					deleteFile(boardToDelete.getBoardImg4(), servletContext);
					log.info(">>파일 삭제 시도 완료.");
				} catch (Exception e) {
					log.error(">>이미지 파일 삭제 중 예외 발생 (DB 삭제는 완료됨), boardId:{}", boardId, e);
				}
			} else {
				log.warn(">>데이터베이스 삭제 실패 (삭제된 행 수 0), boardId:{}", boardId);

				mav.setViewName("redirect:/board/list");
				mav.addObject("msg", "db_delete_failed");
				return mav;
			}

		} catch (Exception e) {
			log.error(">>게시글 삭제 처리 중 예외 발생, boardId:{}", boardId, e);
			// Service에서 발생한 예외 (DB 관련)는 여기서 잡아서 처리
			// 예: 에러 페이지로 이동 또는 메시지 표시
			mav.setViewName("redirect:/board/list");
			mav.addObject("msg", "error");
			return mav;
		}

		log.info(">>BoardControllerImpl-deleteBoard() 호출 종료, DB 삭제된 행 수:{}", dbDeleteResult);

		mav.setViewName("redirect:/board/list");
		mav.addObject("msg", "deleted");
		return mav;
	}

	// 댓글 작성 요청 처리 메소드
	@RequestMapping(value = "/reply/write", method = RequestMethod.POST)
	public String addReply(@ModelAttribute("reply") ReplyVo reply, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		HttpSession session = request.getSession();

		MemberVo loginUser = (MemberVo) session.getAttribute("member");

		if (loginUser != null) {
			reply.setReplyWriter(loginUser.getNick());
			reply.setReplyWriterId(loginUser.getId());
		} else {
			log.warn(">> 댓글 작성 실패: 로그인되지 않은 사용자 요청");
			return "redirect:/board/view?boardId=" + reply.getBoardId() + "&msg=loginRequired";
		}
		boardService.addReply(reply);
		return "redirect:/board/view?boardId=" + reply.getBoardId();
	}

	// 댓글 삭제 처리
	@RequestMapping(value = "/deleteReply", method = RequestMethod.POST) // 또는 GET, AJAX 사용 시 POST 권장
	public ModelAndView deleteReply(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("replyId") int replyId, @RequestParam("boardId") int boardId) throws Exception {

		ModelAndView mav = new ModelAndView();
		// 임시로 member_id를 "admin"으로 설정
		// String currentUserId = "admin";
		HttpSession session = request.getSession();
		MemberVo loginUser = (MemberVo) session.getAttribute("member");

		String currentUserId = null;
		if (loginUser != null) {
			currentUserId = loginUser.getNick();
			log.info(">> 댓글 삭제 요청: replyId={}, 요청 사용자 닉네임={}", replyId, currentUserId);
		} else {
			log.warn(">> 댓글 삭제 실패: 로그인되지 않은 사용자 요청, replyId={}", replyId);
			mav.addObject("msg", "댓글을 삭제하려면 로그인이 필요합니다.");
			mav.setViewName("redirect:/board/view?boardId=" + boardId);
			return mav; // 처리 중단
		}

		try {
			// Service 메서드 내부에서 replyWriter와 currentUserId 비교 로직은 DAO 쿼리에서 처리됨
			int result = boardService.deleteReply(replyId, currentUserId);

			if (result > 0) {
				mav.setViewName("redirect:/board/view?boardId=" + boardId);
			} else {
				log.warn(">>댓글 삭제 실패: replyId={}, 요청 사용자={}", replyId, currentUserId);
				mav.setViewName("redirect:/board/view?boardId=" + boardId);
				mav.addObject("msg", "댓글 삭제에 실패했거나 권한이 없습니다.");
			}
		} catch (Exception e) {
			log.error("댓글 삭제 중 오류 발생, replyId:{}", replyId, e);
			mav.addObject("msg", "댓글 삭제 중 오류가 발생했습니다.");
			// mav.setViewName("errorPage"); // 오류 페이지로 이동
		}
		log.info(">>BoardControllerImpl-deleteReply() 호출 종료");
		return mav;
	}

	// 댓글 수정 처리 (AJAX 요청)
	@RequestMapping(value = "/updateReply", method = RequestMethod.POST)
	@ResponseBody // JSON 응답을 위해 추가
	public Map<String, Object> updateReply(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("replyId") int replyId, @RequestParam("replyCont") String replyCont) throws Exception {

		Map<String, Object> resultMap = new HashMap<>();
		// 임시로 member_id를 "admin"으로 설정
		// String currentUserId = "admin";

		HttpSession session = request.getSession();
		MemberVo loginUser = (MemberVo) session.getAttribute("member");
		String currentUserId = null;

		if (loginUser != null) {
			currentUserId = loginUser.getNick();
		} else {
			log.warn(">> 댓글 수정 실패: 로그인되지 않은 사용자 요청, replyId={}", replyId);
			resultMap.put("status", "fail");
			resultMap.put("message", "댓글을 수정하려면 로그인이 필요합니다.");
			return resultMap;
		}

		try {
			// Service를 통해 댓글 수정 로직 수행
			int result = boardService.updateReply(replyId, replyCont, currentUserId);

			if (result > 0) {
				resultMap.put("status", "success");
				resultMap.put("message", "댓글이 수정되었습니다.");
			} else {
				log.warn(">>댓글 수정 실패: replyId={}, 요청 사용자={}", replyId, currentUserId);
				resultMap.put("status", "fail");
				resultMap.put("message", "댓글 수정에 실패했거나 권한이 없습니다.");
			}
		} catch (Exception e) {
			log.error("댓글 수정 중 오류 발생, replyId:{}", replyId, e);
			resultMap.put("status", "error");
			resultMap.put("message", "댓글 수정 중 오류가 발생했습니다.");
		}
		log.info(">>BoardControllerImpl-updateReply() 호출 종료");
		return resultMap;
	}

	@Override
	@RequestMapping(value = "/like", method = RequestMethod.POST)
	@ResponseBody
	public String boardLike(HttpServletRequest request, HttpServletResponse response, int boardId) throws Exception {
		log.info(">> 게시글 좋아요 처리, boardId: {}", boardId);

		try {
			// 세션에서 로그인한 사용자 정보 가져오기
			HttpSession session = request.getSession();
			MemberVo loginUser = (MemberVo) session.getAttribute("member");

			// 로그인 체크
			if (loginUser == null) {
				log.warn(">> 게시글 좋아요 실패: 로그인되지 않은 사용자 요청");
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter out = response.getWriter();
				out.println("login"); // 클라이언트에게 로그인 필요 메시지 전달
				return null;
			}

			String userId = loginUser.getId(); // 로그인한 사용자 ID
			log.info(">> userId: {}", userId);

			BoardLikeVo likeVo = new BoardLikeVo();
			likeVo.setBoardLikeUser(userId);
			likeVo.setBoardLikePost(boardId);

			boolean result = boardService.addBoardLike(likeVo);

			if (result) {
				// 좋아요 추가 성공 시 해당 게시글의 총 좋아요 수 반환
				int totalLikes = boardService.getBoardLikeCount(boardId);

				// 게시글의 좋아요 수도 업데이트
				boardService.updateBoardLikeCount(boardId, totalLikes);

				return String.valueOf(totalLikes);
			} else {
				return "fail"; // 이미 좋아요를 누른 경우 등 실패
			}
		} catch (Exception e) {
			log.error(">> 게시글 좋아요 처리 중 예외 발생", e);
			return "error"; // 서버 오류
		}
	}

	@Override
	@RequestMapping(value = "/like/cancel", method = RequestMethod.POST)
	@ResponseBody
	public String boardLikeCancel(HttpServletRequest request, HttpServletResponse response, int boardId)
			throws Exception {
		log.info(">> 게시글 좋아요 취소 처리, boardId: {}", boardId);

		try {
			// 세션에서 로그인한 사용자 정보 가져오기
			HttpSession session = request.getSession();
			MemberVo loginUser = (MemberVo) session.getAttribute("member");

			// 로그인 체크
			if (loginUser == null) {
				log.warn(">> 게시글 좋아요 취소 실패: 로그인되지 않은 사용자 요청");
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter out = response.getWriter();
				out.println("login"); // 클라이언트에게 로그인 필요 메시지 전달
				return null;
			}

			String userId = loginUser.getId(); // 로그인한 사용자 ID
			log.info(">> userId: {}", userId);

			BoardLikeVo likeVo = new BoardLikeVo();
			likeVo.setBoardLikeUser(userId);
			likeVo.setBoardLikePost(boardId);

			boolean result = boardService.cancelBoardLike(likeVo);

			if (result) {
				// 좋아요 취소 성공 시 해당 게시글의 총 좋아요 수 반환
				int totalLikes = boardService.getBoardLikeCount(boardId);

				// 게시글의 좋아요 수도 업데이트
				boardService.updateBoardLikeCount(boardId, totalLikes);

				return String.valueOf(totalLikes);
			} else {
				return "fail"; // 좋아요를 누르지 않은 경우 등 실패
			}
		} catch (Exception e) {
			log.error(">> 게시글 좋아요 취소 처리 중 예외 발생", e);
			return "error"; // 서버 오류
		}
	}

	@Override
	@RequestMapping(value = "/like/status", method = RequestMethod.POST)
	@ResponseBody
	public String boardLikeStatus(HttpServletRequest request, HttpServletResponse response, int boardId)
			throws Exception {

		try {
			// 세션에서 로그인한 사용자 정보 가져오기
			HttpSession session = request.getSession();
			MemberVo loginUser = (MemberVo) session.getAttribute("member");

			// 로그인 체크
			if (loginUser == null) {
				log.warn(">> 게시글 좋아요 상태 확인 실패: 로그인되지 않은 사용자 요청");
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter out = response.getWriter();
				out.println("login"); // 클라이언트에게 로그인 필요 메시지 전달
				return null;
			}

			String userId = loginUser.getId(); // 로그인한 사용자 ID
			log.info(">> userId: {}", userId);

			BoardLikeVo likeVo = new BoardLikeVo();
			likeVo.setBoardLikeUser(userId);
			likeVo.setBoardLikePost(boardId);

			boolean isLiked = boardService.checkBoardLikeStatus(likeVo);
			return String.valueOf(isLiked); // true 또는 false 문자열 반환
		} catch (Exception e) {
			log.error(">> 게시글 좋아요 상태 확인 중 예외 발생", e);
			return "error"; // 서버 오류
		}
	}

	@Override
	@RequestMapping(value = "/like/count", method = RequestMethod.POST)
	@ResponseBody
	public String boardLikeCount(HttpServletRequest request, HttpServletResponse response, int boardId)
			throws Exception {
		log.info(">> 게시글 총 좋아요 수 조회, boardId: {}", boardId);

		try {
			int totalLikes = boardService.getBoardLikeCount(boardId);
			return String.valueOf(totalLikes); // 좋아요 수 문자열 반환
		} catch (Exception e) {
			log.error(">> 게시글 총 좋아요 수 조회 중 예외 발생", e);
			return "error"; // 서버 오류
		}
	}

	// 게시글 검색
	@Override
	@RequestMapping(value = "/search", method = RequestMethod.GET)
	public ModelAndView searchBoard(@RequestParam("keyword") String keyword, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView("/board/search");

		try {
			List<BoardVo> resultList = boardService.searchBoards(keyword);

			// 작성자 이미지 매핑
			Map<String, MemberVo> memberCache = new HashMap<>();
			for (BoardVo board : resultList) {
				String writerId = board.getBoardWriterId();
				if (writerId != null && !writerId.isEmpty()) {
					MemberVo writerInfo = memberCache.containsKey(writerId) ? memberCache.get(writerId)
							: memberService.selectMemberById(writerId);
					if (writerInfo != null) {
						board.setBoardWriterImg(writerInfo.getProfileImg());
						memberCache.put(writerId, writerInfo);
					}
				}
			}

			// 인기 게시글 TOP 5 추가
			List<BoardVo> top5List = boardService.getTop5BoardsByViews();
			mav.addObject("top5List", top5List);

			mav.addObject("boardList", resultList);
			mav.addObject("keyword", keyword);
		} catch (Exception e) {
			log.error("검색 중 오류 발생", e);
			mav.setViewName("/board/errorPage");
			mav.addObject("msg", "검색 중 오류가 발생했습니다.");
		}
		return mav;
	}

	// 카테고리별 게시글 목록 - AJAX 요청 처리
	@Override
	@RequestMapping(value = "/listByCategory", method = RequestMethod.GET)
	public String listByCategory(@RequestParam(value = "category", required = false) String category,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		List<BoardVo> boardList;
		if (category == null || category.isEmpty()) {
			boardList = boardService.selectBoardList(); // 모든 게시글 목록
		} else {
			boardList = boardService.getBoardsByCategory(category); // 특정 카테고리 게시글 목록
		}

		// boardList 객체를 JSP에 전달하여 게시글 목록을 렌더링
		request.setAttribute("boardList", boardList);

		return "board/items"; // board/items.jsp에서 게시글 목록만 리턴
	}

	// 관리자용
	@Override
	@RequestMapping("/admin")
	public ModelAndView boardManage(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		ModelAndView mav = new ModelAndView("/admin/board");
		
		// 검색 파라미터 가져오기
	    String searchType = request.getParameter("searchType");
	    String keyword = request.getParameter("keyword");
	    
	    List<BoardVo> boardList;
	    
	    // 검색 조건이 있는 경우
	    if(searchType != null && keyword != null && !keyword.trim().isEmpty()) {
	        log.info("검색 요청: searchType={}, keyword={}", searchType, keyword);
	        boardList = boardService.searchBoardsForAdmin(searchType, keyword);
	    } else {
	        // 검색 조건이 없는 경우 전체 목록 조회
	        boardList = boardService.getAllBoardsForAdmin();
	    }
	    
	    mav.addObject("boardList", boardList);
	    mav.addObject("searchType", searchType); // 검색 폼에 선택된 값 유지
	    mav.addObject("keyword", keyword);       // 검색 폼에 입력된 값 유지
		
		return mav;
	}

	@RequestMapping(value = "/admin/saveOrDelete", method = RequestMethod.POST)
	public String deleteInAdmin(@RequestParam("action") String action,
			@RequestParam(value = "selectedIds", required = false) List<Integer> selectedIds,
			@RequestParam(value = "boards", required = false) List<BoardVo> boards, HttpServletRequest request)
			throws Exception {

		if ("delete".equals(action)) {
			if (selectedIds != null && !selectedIds.isEmpty()) {
				for (int boardId : selectedIds) {
					boardService.deleteBoardFromAdmin(boardId);
				}
			}
		}

		// 작업이 완료된 후 관리자 게시판 목록 페이지로 리다이렉트
		return "redirect:/board/admin";
	}

	// 관리자 게시글 수정 폼
	@Override
	@RequestMapping(value = "/admin/editAdmin/{boardId}", method = RequestMethod.GET)
	public ModelAndView editFormInAdmin(HttpServletRequest request, HttpServletResponse response,
			@PathVariable("boardId") int boardId) throws Exception {
		log.info("관리자 게시글 수정 페이지 요청: boardId={}", boardId);

		ModelAndView mav = new ModelAndView("/board/admEdit");

		try {
			BoardVo board = boardService.getBoardById(boardId);

			if (board == null) {
				log.warn("게시글을 찾을 수 없음: boardId={}", boardId);
				mav.setViewName("redirect:/board/admin");
				return mav;
			}

			mav.addObject("board", board);
			log.info("게시글 정보 로드 완료: boardId={}", boardId);

		} catch (Exception e) {
			log.error("게시글 정보 조회 중 예외 발생: boardId={}", boardId, e);
			mav.addObject("errorMessage", "게시글 정보를 불러오는 중 오류가 발생했습니다.");
		}

		return mav;
	}

	// 관리자 게시글 수정 처리
	@Override
	@RequestMapping(value = "/admin/updateAdmin", method = RequestMethod.POST)
	public String updateInAdminBoard(HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			int boardId = Integer.parseInt(request.getParameter("boardId"));
			String boardWriter = request.getParameter("boardWriter");
			String boardCont = request.getParameter("boardCont");
			String boardCate = request.getParameter("boardCate");

			log.info("관리자 게시글 수정 처리 요청: boardId={}", boardId);

			BoardVo board = new BoardVo();
			board.setBoardId(boardId);
			board.setBoardWriter(boardWriter);
			board.setBoardCont(boardCont);
			board.setBoardCate(boardCate);

			boardService.updateBoardFromAdmin(board);
			log.info("게시글 수정 완료: boardId={}", boardId);

		} catch (Exception e) {
			log.error("게시글 수정 중 예외 발생", e);
		}

		return "redirect:/board/admin";
	}
	
	// 게시글 목록
	@Override
	@RequestMapping(value = "/hots", method = RequestMethod.GET)
	public ModelAndView top100List(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelAndView mav = new ModelAndView("/board/hots");
		try {
			// 로그인한 사용자 정보 가져오기
			HttpSession session = request.getSession();
			MemberVo loginUser = (MemberVo) session.getAttribute("member");

			List<BoardVo> boardList = boardService.selectBoardList();
			Map<String, MemberVo> memberMap = new HashMap<>(); // 닉네임 → MemberVo 캐싱

			if (boardList != null && !boardList.isEmpty()) {
				for (BoardVo board : boardList) {
					int boardId = board.getBoardId();
					// boardService의 getReplyCountByBoardId 메서드를 호출하여 실제 댓글 수를 가져옴
					int actualReplyCount = boardService.getReplyCountByBoardId(boardId);
					board.setBoardRe(actualReplyCount);
					// 좋아요 수 업데이트 (이미 DB에서 가져온 값이 있을 수 있지만, 최신 상태 보장)
					int likeCount = boardService.getBoardLikeCount(boardId);
					board.setBoardLike(likeCount);

					// 로그인한 사용자가 있는 경우 좋아요 상태 확인
					if (loginUser != null) {
						BoardLikeVo likeVo = new BoardLikeVo();
						likeVo.setBoardLikeUser(loginUser.getId());
						likeVo.setBoardLikePost(boardId);

						boolean isLiked = boardService.checkBoardLikeStatus(likeVo);

						// 각 게시글의 좋아요 상태를 Map에 저장
						if (mav.getModel().get("likedPosts") == null) {
							mav.addObject("likedPosts", new HashMap<Integer, Boolean>());
						}
						((Map<Integer, Boolean>) mav.getModel().get("likedPosts")).put(boardId, isLiked);
					}

					// 작성자 프로필 이미지 설정
					String writerId = board.getBoardWriterId();
					if (writerId != null && !writerId.isEmpty()) {
						MemberVo writerInfo = memberMap.get(writerId);
						if (writerInfo == null) {
							writerInfo = memberService.selectMemberById(writerId);
							if (writerInfo != null) {
								memberMap.put(writerId, writerInfo);
							}
						}
						if (writerInfo != null) {
							board.setBoardWriterImg(writerInfo.getProfileImg());
						}
					}
					// 줄바꿈 문자 -> <br />로 변환
					if (board.getBoardCont() != null) {
						String convertedContent = board.getBoardCont().replaceAll("(\r\n|\r|\n)", "<br />");
						board.setBoardCont(convertedContent);
					}
				}
			}
			
			// 인기 게시글 TOP 5 추가
			List<BoardVo> top5List = boardService.getTop5BoardsByViews();
			mav.addObject("top5List", top5List);

			// 인기 게시글 TOP 100 추가
			List<BoardVo> top100List = boardService.getTop100BoardsByViews();
			mav.addObject("top100List", top100List);
			mav.addObject("boardList", boardList);

		} catch (Exception e) {
			log.error("게시글 목록 조회 및 댓글 수 업데이트 중 오류 발생", e);
			mav.addObject("msg", "게시글 목록을 불러오는 중 오류가 발생했습니다.");
		}
		return mav;
	}
	
}
