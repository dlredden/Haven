/*
Jquery and Rails powered default application.js
Easy Ajax replacement for remote_functions and ajax_form based on class name
All actions will reply to the .js format
Unobtrusive, will only works if Javascript enabled, if not, respond to an HTML as a normal link
respond_to do |format|
format.html
format.js {render :layout => false}
end
*/

jQuery.ajaxSetup({ 'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")} })

function _ajax_request(url, data, callback, type, method) {
    if (jQuery.isFunction(data)) {
        callback = data;
        data = {};
    }
    return jQuery.ajax({
        type: method,
        url: url,
        data: data,
        success: callback,
        dataType: type
        });
}

jQuery.extend({
    put: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'PUT');
    },
    delete_: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'DELETE');
    }
});

/*
Submit a form with Ajax
Use the class ajaxForm in your form declaration
<% form_for @comment,:html => {:class => "ajaxForm"} do |f| -%>
*/
jQuery.fn.submitWithAjax = function() {
  this.unbind('submit', false);
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })

  return this;
};

/*
Retreive a page with get
Use the class get in your link declaration
<%= link_to 'My link', my_path(),:class => "get" %>
*/
jQuery.fn.getWithAjax = function() {
  this.unbind('click', false);
  this.click(function() {
    $.get($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

/*
Post data via html
Use the class post in your link declaration
<%= link_to 'My link', my_new_path(),:class => "post" %>
*/
jQuery.fn.postWithAjax = function() {
  this.unbind('click', false);
  this.click(function() {
    $.post($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

/*
Update/Put data via html
Use the class put in your link declaration
<%= link_to 'My link', my_update_path(data),:class => "put",:method => :put %>
*/
jQuery.fn.putWithAjax = function() {
  this.unbind('click', false);
  this.click(function() {
    $.put($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

/*
Delete data
Use the class delete in your link declaration
<%= link_to 'My link', my_destroy_path(data),:class => "delete",:method => :delete %>
*/
jQuery.fn.deleteWithAjax = function() {
  this.removeAttr('onclick');
  this.unbind('click', false);
  this.click(function() {
    $.delete_($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

/*
Ajaxify all the links on the page.
This function is called when the page is loaded. You'll probaly need to call it again when you write render new datas that need to be ajaxyfied.'
*/
function ajaxLinks(){
    $('.ajaxForm').submitWithAjax();
    $('a.get').getWithAjax();
    $('a.post').postWithAjax();
    $('a.put').putWithAjax();
    $('a.delete').deleteWithAjax();
}

$(document).ready(function() {
// All non-GET requests will add the authenticity token
 $(document).ajaxSend(function(event, request, settings) {
       if (typeof(window.AUTH_TOKEN) == "undefined") return;
       // IE6 fix for http://dev.jquery.com/ticket/3155
       if (settings.type == 'GET' || settings.type == 'get') return;

       settings.data = settings.data || "";
       settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window.AUTH_TOKEN);
     });

  ajaxLinks();
});

function buildYUITreeView(treeId, treeData)
{
	var tree = new YAHOO.widget.TreeView(treeId);
	addYUITreeViewChildNodes(0, 0, tree.getRoot(), treeData);
	tree.subscribe("clickEvent",
		function(oArgs)
		{
			if (oArgs.node.isLeaf)
			{
				openFile(oArgs.node.label, oArgs.node.data.projectId, oArgs.node.data.fullFileName);
			}
		}
	);
	tree.render();
	
	function addYUITreeViewChildNodes(currLevel, nodeIndex, parent, treeData)
	{
		var lastNode;
		var level = currLevel;
		while (nodeIndex < treeData.length)
		{
			level = treeData[nodeIndex];
			if (level == currLevel)
			{
				nodeIndex++;
				lastNode = new YAHOO.widget.TextNode(treeData[nodeIndex++], parent);
			}
			else if (level < currLevel)
			{
				return nodeIndex;
			}
			else
			{
				nodeIndex = addYUITreeViewChildNodes(level, nodeIndex, lastNode, treeData);
			}
		}
		
		return nodeIndex;
	}
}

function loadNodeData(node, fnLoadComplete)  {
    
    //We'll create child nodes based on what we get back when we
    //use Connection Manager to pass the text label of the 
    //expanding node to the Yahoo!
    //Search "related suggestions" API.  Here, we're at the 
    //first part of the request -- we'll make the request to the
    //server.  In our Connection Manager success handler, we'll build our new children
    //and then return fnLoadComplete back to the tree.
    
    //Get the node's label and urlencode it; this is the word/s
    //on which we'll search for related words:
    var nodeLabel = encodeURI(node.label);
    
    //prepare URL for XHR request:
    var sUrl = "assets/ysuggest_proxy.php?query=" + nodeLabel;
    
    //prepare our callback object
    var callback = {
    
        //if our XHR call is successful, we want to make use
        //of the returned data and create child nodes.
        success: function(oResponse) {
            YAHOO.log("XHR transaction was successful.", "info", "example");
            console.log(oResponse.responseText);
            var oResults = eval("(" + oResponse.responseText + ")");
            if((oResults.ResultSet.Result) && (oResults.ResultSet.Result.length)) {
                //Result is an array if more than one result, string otherwise
                if(YAHOO.lang.isArray(oResults.ResultSet.Result)) {
                    for (var i=0, j=oResults.ResultSet.Result.length; i<j; i++) {
                        var tempNode = new YAHOO.widget.TextNode(oResults.ResultSet.Result[i], node, false);
                    }
                } else {
                    //there is only one result; comes as string:
                    var tempNode = new YAHOO.widget.TextNode(oResults.ResultSet.Result, node, false)
                }
            }
                                
            //When we're done creating child nodes, we execute the node's
            //loadComplete callback method which comes in via the argument
            //in the response object (we could also access it at node.loadComplete,
            //if necessary):
            oResponse.argument.fnLoadComplete();
        },
        
        //if our XHR call is not successful, we want to
        //fire the TreeView callback and let the Tree
        //proceed with its business.
        failure: function(oResponse) {
            YAHOO.log("Failed to process XHR transaction.", "info", "example");
            oResponse.argument.fnLoadComplete();
        },
        
        //our handlers for the XHR response will need the same
        //argument information we got to loadNodeData, so
        //we'll pass those along:
        argument: {
            "node": node,
            "fnLoadComplete": fnLoadComplete
        },
        
        //timeout -- if more than 7 seconds go by, we'll abort
        //the transaction and assume there are no children:
        timeout: 7000
    };
    
    //With our callback object ready, it's now time to 
    //make our XHR call using Connection Manager's
    //asyncRequest method:
    YAHOO.util.Connect.asyncRequest('GET', sUrl, callback);
}

function setBespinSize()
{
	setDynamicDimensions();
	setTimeout('$(".bespin")[0].bespin.dimensionsChanged();', 100);
}

/*
 * Finds all elements that have a class of dynamic-height or dynamic-width and sets their
 * heights and widths appropriately offset by the heights or widths of all elements that
 * have a class of height-offset or width-offset.
 */
function setDynamicDimensions()
{
	var heightOffset = 0;
	var widthOffset = 0;
	
	// Calculate the height offset
	$(".height-offset").each(function(){
		heightOffset += $(this).outerHeight();
	});
	
	// Calculate the width offset
	$(".width-offset").each(function(){
		widthOffset += $(this).outerWidth();
	});
	
	$(".dynamic-height").each(function(){
		// Take into account this objects margin, border and padding
		var myOffset = 0;
		myOffset += parseInt($(this).css('padding-top'));
		myOffset += parseInt($(this).css('padding-bottom'));
		myOffset += parseInt($(this).css('margin-top'));
		myOffset += parseInt($(this).css('margin-bottom'));
		myOffset += parseInt($(this).css('border-top-width'));
		myOffset += parseInt($(this).css('border-bottom-width'));

		$(this).css("height", $(window).height() - heightOffset - myOffset + "px");
	});
	
	$(".dynamic-width").each(function(){
		// Take into account this objects margin, border and padding
		var myOffset = 0;
		myOffset += parseInt($(this).css('padding-left'));
		myOffset += parseInt($(this).css('padding-right'));
		myOffset += parseInt($(this).css('margin-left'));
		myOffset += parseInt($(this).css('margin-right'));
		myOffset += parseInt($(this).css('border-left-width'));
		myOffset += parseInt($(this).css('border-right-width'));
		
		$(this).css("width", $(window).width() - widthOffset - myOffset + "px");
	});
}
