function jsProtect(f) {
  if (!jsFail) try {
    return f();
  } catch (e) {
    jsFail = true;
  }
}
