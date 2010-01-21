$(function()
{
  // Delete Link Confirmation
  $('a.delete').click(function()
  {
    return confirm("Are you sure you want to delete this?");
  });
});

function setup_highlighter()
{
	SyntaxHighlighter.config.clipboardSwf = '/snippets/syntaxhighlighter/js/clipboard.swf';
	SyntaxHighlighter.config.strings.expandSource = 'expand source';
	SyntaxHighlighter.config.strings.viewSource = 'view source';
	SyntaxHighlighter.config.strings.copyToClipboard = 'copy to clipboard';
	SyntaxHighlighter.config.strings.copyToClipboardConfirmation = 'The code is in your clipboard now';
	SyntaxHighlighter.config.strings.print = 'print';
	SyntaxHighlighter.config.strings.help = '?';
	SyntaxHighlighter.config.strings.alert = '[Snippets]\n\n';
	SyntaxHighlighter.config.strings.noBrush = 'Can\'t find brush for: ';
	SyntaxHighlighter.config.strings.brushNotHtmlScript = 'Brush wasn\'t configured for html-script option: ';
	SyntaxHighlighter.defaults['gutter'] = true;
	SyntaxHighlighter.defaults['tab-size'] = 2;
	SyntaxHighlighter.defaults['wrap-lines'] = true;
	SyntaxHighlighter.all();  
}