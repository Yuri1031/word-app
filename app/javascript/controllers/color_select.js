document.addEventListener('DOMContentLoaded', function () {
    const colorSelect = document.querySelector('.color-box');
    const colorOptions = colorSelect.querySelectorAll('option');
  
    colorOptions.forEach(option => {
      const color = option.textContent; // 色コードが表示されると仮定
      option.style.backgroundColor = color; // 背景色を設定
    });
  });
  