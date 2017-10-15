// Define a new function.
(function () {
  // Variables defined in here will not affect the global scope.
  const window = 'Whoops, at least I only broke my code.';
  console.log(window);
// The extra set of parenthesis here says run the function we just defined.
}());
