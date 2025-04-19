<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
    .banner-container {
        width: 100%;
        height: 600px;
        position: relative;
        overflow: hidden;
        margin-bottom: 30px;
    }

    .slide {
        display: none;
        width: 100%;
        height: 100%;
    }

    .slide img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .active-slide {
        display: block;
    }
    
    .explore-btn {
        position: absolute;
        bottom: 40px;
        left: 50%;
        transform: translateX(-50%);
        background-color: #333;       /* Dark background */
        color: white;                 /* White text */
        padding: 10px 20px;           /* Size */
        border: none;                 /* No border */
        font-size: 16px;              /* Text size */
        cursor: pointer;              /* Pointer on hover */
        font-family: 'Segoe UI', sans-serif;
        transition: background-color 0.3s ease;

    }

    .explore-btn:hover {
        color: #ffffff;
        background-color: #f2515e;
    }
</style>

<div class="banner-container">
    <div class="slide active-slide">
        <img src="src/image/banner-bg3.jpg" alt="Slide 1">
    </div>
    <div class="slide">
        <img src="src/image/banner-bg4.jpeg" alt="Slide 2">
    </div>
    <div class="slide">
        <img src="src/image/banner-bg5.jpg" alt="Slide 3">
    </div>

    <button class="explore-btn" onclick="location.href='ProductPage.jsp'">Explore More</button>
</div>

<script>
    let currentSlide = 0;
    const slides = document.querySelectorAll('.slide');

    function showNextSlide() {
        slides[currentSlide].classList.remove('active-slide');
        currentSlide = (currentSlide + 1) % slides.length;
        slides[currentSlide].classList.add('active-slide');
    }

    setInterval(showNextSlide, 3000);
</script>
