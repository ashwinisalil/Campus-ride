document.addEventListener("DOMContentLoaded", () => {
  const splash = document.getElementById("splashScreen");
  const landingPage = document.querySelector(".landing-page");
  const bubble = document.getElementById("splashBubble");
  const logo = document.getElementById("splashLogo");

  if (!splash || !landingPage) return;

  const showLanding = () => {
    splash.classList.add("hidden");
    landingPage.classList.add("show");
    document.body.classList.add("loaded");
  };

  if (bubble) {
    bubble.style.width = "110px";
    bubble.style.height = "110px";
    bubble.style.top = "50%";
    bubble.style.left = "50%";
    bubble.style.marginTop = "-55px";
    bubble.style.marginLeft = "-55px";
  }

  if (logo) {
    logo.style.opacity = "1";
  }

  window.setTimeout(showLanding, 2600);

  document.querySelectorAll(".auth-card").forEach((button) => {
    button.addEventListener("click", (event) => {
      const rect = button.getBoundingClientRect();
      const ripple = document.createElement("span");
      ripple.className = "ripple";
      ripple.style.left = `${event.clientX - rect.left}px`;
      ripple.style.top = `${event.clientY - rect.top}px`;
      button.appendChild(ripple);
      setTimeout(() => ripple.remove(), 700);
    });
  });
});