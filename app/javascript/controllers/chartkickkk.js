document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".chart").forEach(function (canvas) {
      let ctx = canvas.getContext("2d");
      let score = canvas.dataset.score; // 正答率
      let data = {
        labels: ["正解", "不正解"],
        datasets: [
          {
            data: [score, 100 - score], // 正答率と残り
            backgroundColor: ["#4CAF50", "#ddd"], // 緑とグレー
          },
        ],
      };
  
      new Chart(ctx, {
        type: "doughnut",
        data: data,
        options: {
          responsive: true,
          cutout: "70%", // 円の中央をくり抜く
          plugins: {
            legend: { display: false },
          },
        },
      });
    });
  });
  