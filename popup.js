const ext = globalThis.browser ?? globalThis.chrome;

const SETTINGS = {
  noAutoplay: 'nytCleanerAutoplayBlock',
  noTimesAds: 'nytCleanerNoTimesAds'
};

async function loadSettings() {
  const values = await ext.storage.local.get({
    [SETTINGS.noAutoplay]: true,
    [SETTINGS.noTimesAds]: true
  });

  document.getElementById('noAutoplay').checked = values[SETTINGS.noAutoplay] !== false;
  document.getElementById('noTimesAds').checked = values[SETTINGS.noTimesAds] !== false;
}

function wireCheckbox(id, key) {
  const checkbox = document.getElementById(id);
  checkbox.addEventListener('change', async () => {
    await ext.storage.local.set({ [key]: checkbox.checked });
  });
}

document.addEventListener('DOMContentLoaded', () => {
  loadSettings();
  wireCheckbox('noAutoplay', SETTINGS.noAutoplay);
  wireCheckbox('noTimesAds', SETTINGS.noTimesAds);
});
