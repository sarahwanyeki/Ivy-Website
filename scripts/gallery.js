// Image Gallery Lightbox Functionality
const galleryItems = document.querySelectorAll('.gallery-page__item');
const lightbox = document.getElementById('lightbox');
const lightboxImage = document.getElementById('lightboxImage');
const closeLightboxBtn = document.getElementById('closeLightbox');
const prevImageBtn = document.getElementById('prevImage');
const nextImageBtn = document.getElementById('nextImage');

let currentImageIndex = 0;
const imagesSources = [];

// Collect all image sources
galleryItems.forEach((item, index) => {
  const img = item.querySelector('img');
  if (img) {
    imagesSources.push(img.src);

    // Add click event to open lightbox
    item.addEventListener('click', () => {
      openLightbox(index);
    });
  }
});

// Open lightbox with specific image
function openLightbox(index) {
  currentImageIndex = index;
  lightboxImage.src = imagesSources[currentImageIndex];
  lightbox.classList.add('active');
  document.body.style.overflow = 'hidden';
}

// Close lightbox
function closeLightbox() {
  lightbox.classList.remove('active');
  document.body.style.overflow = 'auto';
}

// Show previous image
function showPreviousImage() {
  currentImageIndex = (currentImageIndex - 1 + imagesSources.length) % imagesSources.length;
  lightboxImage.src = imagesSources[currentImageIndex];
}

// Show next image
function showNextImage() {
  currentImageIndex = (currentImageIndex + 1) % imagesSources.length;
  lightboxImage.src = imagesSources[currentImageIndex];
}

// Event listeners
if (closeLightboxBtn) {
  closeLightboxBtn.addEventListener('click', closeLightbox);
}

if (prevImageBtn) {
  prevImageBtn.addEventListener('click', showPreviousImage);
}

if (nextImageBtn) {
  nextImageBtn.addEventListener('click', showNextImage);
}

// Close lightbox when clicking outside the image
if (lightbox) {
  lightbox.addEventListener('click', (e) => {
    if (e.target === lightbox) {
      closeLightbox();
    }
  });
}

// Keyboard navigation
document.addEventListener('keydown', (e) => {
  if (!lightbox.classList.contains('active')) return;

  if (e.key === 'Escape') {
    closeLightbox();
  } else if (e.key === 'ArrowLeft') {
    showPreviousImage();
  } else if (e.key === 'ArrowRight') {
    showNextImage();
  }
});
