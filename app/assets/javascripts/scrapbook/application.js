//= require scrapbook/turbo.min

function ready(fn) {
  if (document.readyState !== 'loading') {
    fn()
  } else {
    document.addEventListener('DOMContentLoaded', fn)
  }
}
ready(() => {
  const scrapbook_root_path = document.head.querySelector("meta[name=scrapbook-root]").content

  function buildInitialTree() {
    const paths = window.location.pathname.substring(scrapbook_root_path.length).split("/")
    if (paths.length === 1 && paths[0] === "") { return }

    fetch(scrapbook_root_path)
      .then((response) => response.text())
      .then((data) => {
        const root = document.createElement('html')
        const nav = document.getElementById('folder_listing')
        const frame = nav.querySelector('turbo-frame')

        root.innerHTML = data
        // Keep the nav element to keep listeners on it intact.
        nav.innerHTML = root.querySelector('#folder_listing').innerHTML
        setCurrent()

        openFolderPath(window.location.pathname, scrapbook_root_path + paths[0])
      })
      .catch((error) => {
        console.error("Unknown error:", error)
      })
  }

  function openFolderPath(path, currentSubPath = scrapbook_root_path) {
    const frame = document.querySelector('turbo-frame[src="' + currentSubPath + '"]')
    if (!frame) { return }

    if (path !== currentSubPath)
      frame.addEventListener('turbo:frame-render', () => {
        nextSegment = path.replace(currentSubPath + '/', '').split('/')[0]
        openFolderPath(path, currentSubPath + '/' + nextSegment)
      }, {once: true})
    frame.parentElement.open = true
  }

  function runOpenFor(ids) {
    const idsLeft = []
    const framesFound = []

    ids.forEach((id) => {
      let frame = document.getElementById(id)
      !frame ? idsLeft.push(id) : framesFound.push(frame)
    })

    framesFound.forEach((frame) => {
      frame.addEventListener('turbo:frame-render', () => {
        runOpenFor(idsLeft)
      }, {once: true})
      frame.parentElement.open = true
    })
  }

  function setCurrent(link = document.querySelector('#folder_listing a[href="' + window.location.pathname + '"]')) {
    if (link === null) { return }

    oldSelection = document.querySelector('#folder_listing a[aria-current="page"]')
    if (oldSelection == link) { return }

    if (oldSelection) {
      oldSelection.removeAttribute('aria-current', 'page')
    }

    link.setAttribute('aria-current', 'page')
  }


  buildInitialTree()
  folderListingElem = document.getElementById("folder_listing")

  // Update selection when a link is clicked
  folderListingElem.addEventListener('click', (e) => {
    const target = e.target
    if (target.tagName != 'A') { return }

    setCurrent(target)
  })

  // Every time a folder is opened, it's possible to be re-revealing the selected page.
  folderListingElem.addEventListener('turbo:frame-render', () => {
    setCurrent()
  })

  // Refresh trees when a folder is toggled back open
  // The first time a details element is toggled open, the turbo frame lazily loads. This
  // adds support for reloading whenever the element is closed and then re-opened. All
  // turbo frames of any nested folders are also refreshed.
  folderListingElem.addEventListener('toggle', (e) => {
    if (!e.target.open) { return }
    if ('loadedOnce' in e.target.dataset === false) {
      e.target.dataset.loadedOnce = true
      return
    }

    const idsToOpen = []
    e.target.querySelectorAll('details[open] > turbo-frame').forEach(elem => idsToOpen.push(elem.id))

    const firstFrame = document.getElementById(idsToOpen.shift())
    firstFrame.addEventListener('turbo:frame-render', () => {
      runOpenFor(idsToOpen)
    }, {once: true})
    firstFrame.reload()
  }, {capture: true})
})
