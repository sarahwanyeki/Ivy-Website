// Video Gallery Modal Functionality
const videoGalleryItems = document.querySelectorAll('.video-gallery__item');
const videoLightbox = document.getElementById('videoLightbox');
const lightboxVideo = document.getElementById('lightboxVideo');
const lightboxVideoTitle = document.getElementById('lightboxVideoTitle');
const closeVideoLightboxBtn = document.getElementById('closeVideoLightbox');

// Open video in modal when clicking on gallery item or play button
videoGalleryItems.forEach((item) => {
  const playBtn = item.querySelector('.video-gallery__playBtn');
  const videoSrc = item.getAttribute('data-video');
  const videoTitle = item.getAttribute('data-title');

  // Click on play button
  if (playBtn) {
    playBtn.addEventListener('click', (e) => {
      e.stopPropagation();
      openVideoLightbox(videoSrc, videoTitle);
    });
  }

  // Click anywhere on the item
  item.addEventListener('click', () => {
    openVideoLightbox(videoSrc, videoTitle);
  });
});

// Open video lightbox
function openVideoLightbox(videoSrc, videoTitle) {
  lightboxVideo.querySelector('source').src = videoSrc;
  lightboxVideo.load();
  lightboxVideoTitle.textContent = videoTitle;
  videoLightbox.classList.add('active');
  document.body.style.overflow = 'hidden';

  // Auto-play video when modal opens
  lightboxVideo.play();
}

// Close video lightbox
function closeVideoLightbox() {
  videoLightbox.classList.remove('active');
  document.body.style.overflow = 'auto';
  lightboxVideo.pause();
  lightboxVideo.currentTime = 0;
}

// Close button
if (closeVideoLightboxBtn) {
  closeVideoLightboxBtn.addEventListener('click', closeVideoLightbox);
}

// Close when clicking outside the video
if (videoLightbox) {
  videoLightbox.addEventListener('click', (e) => {
    if (e.target === videoLightbox) {
      closeVideoLightbox();
    }
  });
}

// Keyboard navigation
document.addEventListener('keydown', (e) => {
  if (!videoLightbox.classList.contains('active')) return;

  if (e.key === 'Escape') {
    closeVideoLightbox();
  }
});

// Lazy load video thumbnails
const thumbnailVideos = document.querySelectorAll('.video-gallery__thumbnail video');

if ('IntersectionObserver' in window) {
  const videoObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        const video = entry.target;
        if (entry.isIntersecting) {
          // Load first frame when video comes into view
          video.load();
        }
      });
    },
    {
      threshold: 0.1,
      rootMargin: '100px',
    }
  );

  thumbnailVideos.forEach((video) => {
    video.setAttribute('preload', 'metadata');
    videoObserver.observe(video);
  });
}
