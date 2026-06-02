// Mobile nav toggle
const navBtn = document.getElementById('navToggle');
const navLinks = document.getElementById('navLinks');
if (navBtn && navLinks) {
    navBtn.addEventListener('click', () => navLinks.classList.toggle('open'));
    navLinks.addEventListener('click', e => {
        if (e.target.tagName === 'A') navLinks.classList.remove('open');
    });
}

// Hide video placeholder once the file is actually playable
document.querySelectorAll('.video-wrap').forEach(wrap => {
    const video = wrap.querySelector('video');
    const placeholder = wrap.querySelector('.video-placeholder');
    if (!video || !placeholder) return;

    const hide = () => placeholder.style.display = 'none';
    video.addEventListener('loadeddata', hide);
    video.addEventListener('canplay', hide);

    const source = video.querySelector('source');
    if (source) {
        fetch(source.src, { method: 'HEAD' })
            .then(r => { if (r.ok) hide(); })
            .catch(() => { /* placeholder stays */ });
    }
});
