// Navigation Menu
const navMenu = document.querySelector('.navigation');
const navButton = document.querySelector('#navigation-button');
let isMenuActive = false;

const navButtonLinks = document.querySelectorAll('.navigation li a');

navButtonLinks.forEach(link => {
  link.addEventListener('click', () => {
    const navIconMenu = `<i class="bi bi-list"></i>`;
    navButton.innerHTML = navIconMenu;
    isMenuActive = false;
    navMenu.classList.remove('show');
    navMenu.classList.remove('animate__animated');
    navMenu.classList.remove('animate__bounceInLeft');
  });
});

if (navButton && navMenu) {
  navButton.addEventListener('click', () => {
    if (!isMenuActive) {
      const navIconClose = `<i class="bi bi-x-lg"></i>`;
      navButton.innerHTML = navIconClose;
      isMenuActive = true;
    } else {
      const navIconMenu = `<i class="bi bi-list"></i>`;
      navButton.innerHTML = navIconMenu;
      isMenuActive = false;
    }
    // Show and Hide Menu
    navMenu.classList.toggle('show');
    navMenu.classList.toggle('animate__animated');
    navMenu.classList.toggle('animate__bounceInLeft');
  });
}

// Splidejs Slide
const splideRoot = document.querySelector('.splide');
if (splideRoot && window.Splide) {
  const splide = new Splide(splideRoot, {
    type: 'loop',
    direction: 'ltr',
    width: '72%',
    height: '40rem',
    autoplay: true,
    perPage: 1,
    breakpoints: {
      1100: { height: '42rem', width: '90%' },
      720: { height: '46rem', width: '100%' },
      400: { height: '50rem' }
    }
  });
  splide.mount();
}

// Scroll Reveal
if (window.ScrollReveal) {
  ScrollReveal().reveal('.about', { delay: 300 });
  ScrollReveal().reveal('.testimonials', { delay: 300 });
  ScrollReveal().reveal('.contact', { delay: 300 });
}

// Homepage Image lightbox for Work > Design gallery
const workImages = document.querySelectorAll('.work__item img');
const homeImageLightbox = document.getElementById('lightbox');
const homeLightboxImage = document.getElementById('lightboxImage');
const homeCloseLightboxBtn = document.getElementById('closeLightbox');

function openHomeImageLightbox(src) {
  if (!homeImageLightbox || !homeLightboxImage) return;
  homeLightboxImage.src = src;
  homeImageLightbox.classList.add('active');
  document.body.style.overflow = 'hidden';
}

function closeHomeImageLightbox() {
  if (!homeImageLightbox) return;
  homeImageLightbox.classList.remove('active');
  document.body.style.overflow = 'auto';
}

if (homeCloseLightboxBtn) {
  homeCloseLightboxBtn.addEventListener('click', closeHomeImageLightbox);
}
if (homeImageLightbox) {
  homeImageLightbox.addEventListener('click', (e) => {
    if (e.target === homeImageLightbox) closeHomeImageLightbox();
  });
}
document.addEventListener('keydown', (e) => {
  if (homeImageLightbox && homeImageLightbox.classList.contains('active') && e.key === 'Escape') {
    closeHomeImageLightbox();
  }
});

workImages.forEach(img => {
  img.style.cursor = 'zoom-in';
  img.addEventListener('click', () => openHomeImageLightbox(img.src));
});

// Work Gallery - Homepage video lightbox functionality
const videoItems = document.querySelectorAll('.work__videoItem');
const homeVideoLightbox = document.getElementById('videoLightbox');
const homeLightboxVideo = document.getElementById('lightboxVideo');
const homeLightboxVideoTitle = document.getElementById('lightboxVideoTitle');
const homeCloseVideoLightboxBtn = document.getElementById('closeVideoLightbox');

function openHomeVideoLightbox(src, title) {
  const source = homeLightboxVideo.querySelector('source');
  source.src = src;
  homeLightboxVideo.load();
  homeLightboxVideoTitle.textContent = title || '';
  homeVideoLightbox.classList.add('active');
  document.body.style.overflow = 'hidden';
  try { homeLightboxVideo.play(); } catch (e) {}
}

function closeHomeVideoLightbox() {
  homeVideoLightbox.classList.remove('active');
  document.body.style.overflow = 'auto';
  homeLightboxVideo.pause();
  homeLightboxVideo.currentTime = 0;
}

if (homeCloseVideoLightboxBtn) {
  homeCloseVideoLightboxBtn.addEventListener('click', closeHomeVideoLightbox);
}
if (homeVideoLightbox) {
  homeVideoLightbox.addEventListener('click', (e) => {
    if (e.target === homeVideoLightbox) closeHomeVideoLightbox();
  });
}
document.addEventListener('keydown', (e) => {
  if (homeVideoLightbox && homeVideoLightbox.classList.contains('active') && e.key === 'Escape') {
    closeHomeVideoLightbox();
  }
});

videoItems.forEach((item) => {
  const playBtn = item.querySelector('.work__playBtn');
  const vidEl = item.querySelector('video');
  const titleEl = item.querySelector('.work__videoTitle');
  const src = vidEl ? vidEl.getAttribute('src') : '';
  const title = titleEl ? titleEl.textContent.trim() : '';

  function handleOpen(e) {
    if (e) e.stopPropagation();
    openHomeVideoLightbox(src, title);
  }

  if (playBtn) playBtn.addEventListener('click', handleOpen);
  item.addEventListener('click', handleOpen);
});

// Lazy-load and reveal first frame for homepage video thumbnails
const homeThumbVideos = document.querySelectorAll('.work__videoItem video');
if ('IntersectionObserver' in window && homeThumbVideos.length) {
  const homeObserver = new IntersectionObserver(
    entries => {
      entries.forEach(entry => {
        const vid = entry.target;
        if (entry.isIntersecting) {
          // Ensure metadata loads to render first frame
          vid.setAttribute('preload', 'metadata');
          try { vid.load(); } catch (e) {}
        }
      });
    },
    { threshold: 0.1, rootMargin: '100px' }
  );

  homeThumbVideos.forEach(v => {
    v.setAttribute('preload', 'metadata');
    homeObserver.observe(v);
  });
}
