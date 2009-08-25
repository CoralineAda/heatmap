/**
 * $Id: editor_plugin_src.js 539 2008-01-14 19:08:58Z spocke $
 *
 * @author Moxiecode
 * @copyright Copyright © 2004-2008, Moxiecode Systems AB, All rights reserved.
 */

(function() {
	tinymce.create('tinymce.plugins.PDFPlugin', {
		init : function(ed, url) {
			this.editor = ed;

			// Register commands
			ed.addCommand('mcePDF', function() {
				var se = ed.selection;

				// No selection and not in link
				if (se.isCollapsed() && !ed.dom.getParent(se.getNode(), 'A'))
					return;

				ed.windowManager.open({
//					file : url + '/link.htm',
          file: '/pdf_assets/mce_dialog',
					width : 480 + parseInt(ed.getLang('pdf.delta_width', 0)),
					height : 400 + parseInt(ed.getLang('pdf.delta_height', 0)),
					inline : 1
				}, {
					plugin_url : url
				});
			});

			// Register buttons
			ed.addButton('pdf', {
				title : 'pdf.pdf_desc',
				cmd : 'mcePDF',
				image: url + '/img/pdf.gif'
			});

			ed.onNodeChange.add(function(ed, cm, n, co) {
				cm.setDisabled('pdf', co && n.nodeName != 'A');
				cm.setActive('pdf', n.nodeName == 'A' && !n.name);
			});
		},

		getInfo : function() {
			return {
				longname : 'PDFPlugin',
				author : 'SEO Logic',
				authorurl : 'http://www.seologic.com',
				infourl : 'http://www.seologic.com',
				version : tinymce.majorVersion + "." + tinymce.minorVersion
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('pdf', tinymce.plugins.PDFPlugin);
})();