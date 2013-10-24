describe("VoteWidget Javascript", function() {
  it("redirects to ask widget", function() {
    var fakeWindow = { location: { href: "fake url" } };
    redirectToAskWidget(fakeWindow);
    expect(fakeWindow.location).toEqual("/ask_widget")
  });

  it("asks window to timeout", function() {
    spyOn(window, 'setTimeout');
    delayedRedirect(window);
    expect(window.setTimeout).toHaveBeenCalledWith('redirectToAskWidget', 3000);
  });
});
