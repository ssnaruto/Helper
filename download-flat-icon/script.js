(function () {
  var url = window.location.href.split("?")[0];
  var filename = url.split("/")[url.split("/").length - 1];
  var id = filename.split("_")[1];
  if (!id) {
    alert("You can only download svg icon while viewing an icon.");
    return;
  }
  var onlyName = filename.split("_")[0];
  function downloadURI(uri, name) {
    var link = document.createElement("a");
    link.setAttribute("download", name);
    link.href = uri;
    document.body.appendChild(link);
    link.click();
    link.remove();
  }
  var loggedin = document.getElementById("gr_connected");
  if (!loggedin) {
    alert("Please login before clicking on me.");
    return;
  }
  fetch("https://www.flaticon.com/editor/icon/svg/" + id + "?type=standard")
    .then(function (response) {
      return response.json();
    })
    .then((data) => {
      downloadURI(data.url, onlyName + ".svg");
    })
    .catch((error) => {
      alert("Something went wrong >.<");
    });
})();
