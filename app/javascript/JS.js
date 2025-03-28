/////// toggle //////
function setupMarkToggle() {
  const checkbox = document.getElementById('mark_toggle');
  if (!checkbox) return;
  console.log('Checkbox found:', checkbox);

  checkbox.addEventListener('change', () => {
    const wordId = checkbox.dataset.wordId;
    const token = document.querySelector('meta[name="csrf-token"]').content;

    console.log(`Toggling word ID: ${wordId}`);

    fetch(`/words/${wordId}/word_marks/toggle`, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': token,
        'Content-Type': 'application/json'
      }
    }).then(response => response.json())
      .then(data => {
        console.log('Response:', data);

        if (data.dif === 1) {
          console.log('ON');
        } else {
          console.log('OFF');
        }
      }).catch(error => {
        console.error('Error:', error);
        alert('通信エラーが発生しました');
        checkbox.checked = !checkbox.checked;
      });
  });
}
document.addEventListener('turbo:frame-load', setupMarkToggle);



/////// menu //////
window.addEventListener('turbo:frame-load', function() {
  const menuToggles = document.querySelectorAll(".menu-toggle");

  menuToggles.forEach(toggle => {
    // 重複登録を防ぐ（イベント付け直し時）
    toggle.replaceWith(toggle.cloneNode(true));
  });

  const newMenuToggles = document.querySelectorAll(".menu-toggle");

  newMenuToggles.forEach(toggle => {
    const button = toggle.closest('.menu-button');
    const pullDown = button.querySelector(".menu1-lists");

    toggle.addEventListener('click', function(e) {
      e.stopPropagation();

      // 他のメニューを全部閉じる
      document.querySelectorAll('.menu1-lists').forEach(otherPullDown => {
        if (otherPullDown !== pullDown) {
          otherPullDown.classList.add("hidden");
        }
      });

      pullDown.classList.toggle("hidden");
    });
  });

  window.addEventListener('click', function() {
    document.querySelectorAll('.menu1-lists').forEach(pullDown => {
      pullDown.classList.add("hidden");
    });
  });
});


/////// study filter //////
document.addEventListener("DOMContentLoaded", () => {
  const filterRadios = document.querySelectorAll('input[name="radi filter"]');
  const orderRadios = document.querySelectorAll('input[name="radi order"]');
  const cards = document.querySelectorAll('.card');

  function filterAndSort() {
    // フィルター条件
    const filterValue = document.querySelector('input[name="radi filter"]:checked')?.nextSibling.nodeValue.trim();
    const orderValue = document.querySelector('input[name="radi order"]:checked')?.nextSibling.nodeValue.trim();

    cards.forEach(card => {
      const isMarked = card.getAttribute('data-marked') === 'true';

      // フィルター処理
      if (filterValue === "マークのみ" && !isMarked) {
        card.style.display = "none";
      } else {
        card.style.display = "";
      }
    });

    // 並び替え処理
    const cardContainer = document.querySelector('.card_space');
    let cardsArray = Array.from(cards).filter(c => c.style.display !== "none");

    if (orderValue === "ランダム") {
      cardsArray.sort(() => Math.random() - 0.5);
    }

    // 再描画
    cardsArray.forEach(card => {
      cardContainer.appendChild(card);
    });
  }

  filterRadios.forEach(radio => {
    radio.addEventListener('change', filterAndSort);
  });

  orderRadios.forEach(radio => {
    radio.addEventListener('change', filterAndSort);
  });
});
