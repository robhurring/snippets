$(function()
{
  // Delete Link Confirmation
  $('a.delete').click(function()
  {
    return confirm("Are you sure you want to delete this?");
  });
});