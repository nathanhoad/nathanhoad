function queryAll(selector, parent) {
  return [].slice.call(document.querySelectorAll(selector, parent));
}

window.addEventListener("DOMContentLoaded", function() {
  //
  // Image captions
  //
  queryAll("img + br + em, a + br + em").forEach(function(em) {
    var p = em.parentElement;
    var figure = document.createElement("figure");

    // Bail out if the main element is a link but not an image
    if (p.firstElementChild.tagName === "A" && !p.firstElementChild.querySelector("img")) return;

    // Add image (or link if it is one)
    figure.appendChild(p.firstElementChild);

    // Add the caption
    var figcaption = document.createElement("figcaption");
    figcaption.innerHTML = em.innerHTML;
    figure.appendChild(figcaption);

    p.parentElement.insertBefore(figure, p);
    p.parentElement.removeChild(p);
  });

  //
  // Quotes
  //
  queryAll("blockquote").forEach(function(quote) {
    var lines = [].slice.call(quote.children);
    var lastLine = lines[lines.length - 1];

    if (lastLine.querySelector('a[href*="twitter.com/nathanhoad/status"]')) {
      quote.className = "tweet";
      quote.removeChild(lastLine);
      lastLine.innerHTML = lastLine.innerHTML.replace("--", "");
      // Published time
      var time = lastLine.querySelector("a");
      time.className = "tweet-time";
      lastLine.removeChild(time);
      quote.appendChild(time);
      // Profile
      var matches = lastLine.innerText.match(/([^\(]+)\(([^\)]+)/, "");
      var name = matches[1].trim();
      var verified = name.endsWith("*");
      name = name.replace(/\*$/, "");
      var handle = matches[2];
      var author = document.createElement("a");
      author.href = "https://twitter.com/" + handle.replace("@", "");
      author.className = "tweet-profile";
      author.innerHTML =
        '<img src="/twitter-profile.jpg" /><strong>' + name + (verified ? " <em>✔</em>" : "") + "</strong> " + handle;
      quote.insertBefore(author, quote.firstElementChild);
    } else if (lastLine.innerText.startsWith("--")) {
      lastLine.className = "author";
      lastLine.innerHTML = lastLine.innerHTML.replace(/^\-\-/, "&mdash;");
    }
  });

  //
  // General sections
  //
  queryAll('section[data-type="wide"]').forEach(function(section) {
    section.className = "section-wide";
  });

  queryAll('section[data-type="full"]').forEach(function(section) {
    section.className = "section-full";
  });

  queryAll('section[data-type="pull-right"]').forEach(function(section) {
    section.className = "section-right";
  });

  queryAll('section[data-type="pull-left"]').forEach(function(section) {
    section.className = "section-left";
  });

  //
  // Full screen scrolly sections
  //
  queryAll('section[data-type="block"]').forEach(function(section) {
    // The first element is the background
    var media = section.firstElementChild;
    var caption;

    switch (media.tagName) {
      case "FIGURE":
        caption = media.querySelector("figcaption");
        media = media.querySelector("img");
        break;

      case "IMG":
        // Do nothing. We already have the image
        break;

      case "VIDEO":
        // Do nothing. We already have the video
        break;

      default:
        media = media.querySelector("img");
    }

    // No background found so bail early
    if (!media) return;

    section.className = "section-block";

    section.removeChild(section.firstElementChild);

    // Set up the fixed background
    var background = document.createElement("div");
    background.className = "block-background";
    background.appendChild(media);
    if (caption) {
      background.appendChild(caption);
    }
    section.insertBefore(background, section.firstElementChild);

    // All other children get put into little boxes
    [].slice.call(section.children).forEach(function(child) {
      if (child.tagName !== "P") return;

      var panel = document.createElement("div");
      panel.className = "block-panel";
      if (section.getAttribute("data-colour") === "light") {
        panel.className += " block-panel-light";
      }
      panel.appendChild(child);
      section.appendChild(panel);
    });
  });

  //
  // Galleries
  //
  queryAll('section[data-type="gallery"]').forEach(function(section) {
    section.className = "section-wide section-gallery";

    var items = [].slice.call(section.children);
    items.forEach(function(child) {
      section.removeChild(child);
    });

    // Set up rows
    var rowClasses = ["one", "two", "three", "four"];
    var rowCounts = (section.getAttribute("data-layout") || "").split(",").map(function(n) {
      return parseInt(n, 10);
    });
    for (var r = 0; r < rowCounts.length; r++) {
      var row = document.createElement("div");
      row.className = "row " + rowClasses[rowCounts[r] - 1];
      section.appendChild(row);
      for (var i = 0; i < rowCounts[r]; i++) {
        row.appendChild(items.shift());
      }
    }
  });
});
