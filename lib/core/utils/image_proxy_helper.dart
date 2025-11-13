String getProxiedImageUrl(String url) {
  // For web, we need to use a proxy to avoid CORS issues.
  // This is a public proxy for development purposes.
  // For a production app, you should host your own proxy.
  return 'https://cors-anywhere.herokuapp.com/$url';
}
