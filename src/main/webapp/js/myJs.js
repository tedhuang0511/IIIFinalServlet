const img = document.getElementById("prodimg4")
img.addEventListener("error", function(event) {
    event.target.src = "https://www.jotform.com/resources/assets/icon/jotform-icon-dark-800x800.png"
    event.onerror = null
})
img.addEventListener("click", function(event) {
    alert("123123")
})