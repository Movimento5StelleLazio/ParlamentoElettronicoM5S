--
-- Creates an image
--
-- image           (string)
--
-- Example:
--
--  ui_deprecated.image({
--    image = 'test.png',
--  })
--

function ui_deprecated.image(args)
  assert(args.image, "No image argument given.")
  slot.put(
    '<img src="',
    request.get_relative_baseurl(),
    'static/',
    args.image,
    '" />'
  )
end
