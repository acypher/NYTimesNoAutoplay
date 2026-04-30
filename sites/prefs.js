/**
 * Isolated-world preference bridge.
 *
 * MAIN-world scripts cannot read extension storage directly, so mirror settings
 * into sessionStorage before the NYT page scripts finish initializing.
 */
(function() {
  const ext = globalThis.browser ?? globalThis.chrome;
  const h = window.location.hostname;
  const onNyt =
    h === 'www.nytimes.com' ||
    h === 'nytimes.com' ||
    (typeof h === 'string' && h.endsWith('.nytimes.com'));
  if (!onNyt || !ext?.storage?.local) return;

  const SETTINGS = {
    nytCleanerNoAutoplay: 'nytCleanerNoAutoplay',
    nytCleanerNoTimesAds: 'nytCleanerNoTimesAds',
    nytCleanerPrefsReady: 'nytCleanerPrefsReady'
  };

  function merged(values) {
    return {
      nytCleanerNoAutoplay: values.nytCleanerNoAutoplay !== false,
      nytCleanerNoTimesAds: values.nytCleanerNoTimesAds !== false
    };
  }

  function mirror(values) {
    try {
      ['nytCleanerNoAutoplay', 'nytCleanerNoTimesAds'].forEach(key => {
        const enabled = values[key] !== false;
        sessionStorage.setItem(SETTINGS[key], enabled ? '1' : '0');
      });
      sessionStorage.setItem(SETTINGS.nytCleanerPrefsReady, '1');
    } catch (_) {}
  }

  mirror({
    nytCleanerNoAutoplay: true,
    nytCleanerNoTimesAds: true
  });

  try {
    ext.storage.local.get(
      {
        nytCleanerNoAutoplay: true,
        nytCleanerNoTimesAds: true
      },
      values => mirror(merged(values))
    );

    ext.storage.onChanged.addListener((changes, area) => {
      if (area !== 'local') return;
      const next = {
        nytCleanerNoAutoplay: isSessionEnabled('nytCleanerNoAutoplay'),
        nytCleanerNoTimesAds: isSessionEnabled('nytCleanerNoTimesAds'),
        nytCleanerPrefsReady: true
      };
      let changed = false;
      Object.keys(SETTINGS).forEach(key => {
        if (changes[key]) {
          next[key] = changes[key].newValue !== false;
          changed = true;
        }
      });
      if (changed) mirror(next);
    });
  } catch (_) {
    mirror({
      nytCleanerNoAutoplay: true,
      nytCleanerNoTimesAds: true
    });
  }

  function isSessionEnabled(key) {
    try {
      return sessionStorage.getItem(key) !== '0';
    } catch (_) {
      return true;
    }
  }
})();
