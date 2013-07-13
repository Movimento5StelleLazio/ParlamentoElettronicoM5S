
partialload_queue = [];
partialload_queueRPos = 0;
partialload_queueWPos = 0;

function partialload_getFormKeyValuePairs(form) {
  var result = {};
  for (var i=0; i<form.elements.length; i++) {
    var inputElement = form.elements[i];
    var key = inputElement.name;
    var value = inputElement.value;
    if (result[key] == null) result[key] = value;
    else if (typeof(result[key]) == "object") {
      result[key][result[key].length] = value;
    } else {
      result[key] = [result[key], value];
    }
  }
  return result;
}

function partialload_encodeFormData(params) {
  var result = "";
  for (var key in params) {
    var value = params[key];
    if (typeof(value) == "string") {
      if (result != "") result += "&";
      result += encodeURIComponent(key) + "=" + encodeURIComponent(value);
    } else if (typeof(value) == "object") {
      var i;
      for (i=0; i<value.length; i++) {
        if (result != "") result += "&";
        result += encodeURIComponent(key) + "=" + encodeURIComponent(value[i]);
      }
    }
  }
  return result;
}

function partialload_addFormDataToUrl(url, params) {
  if (params != null && typeof(params) != "string") {
    params = partialload_encodeFormData(params);
  }
  if (params != null) {
    if (url.search(/\?/) >= 0) {
      if (url.search(/&$/) >= 0) {
        url = url + params;
      } else {
        url = url + "&" + params;
      }
    } else {
      url = url + "?" + params;
    }
  }
  return url;
}

function partialload_mergeEncodedFormData(data1, data2) {
  if (data2 == null || data2 == "") return data1;
  if (data1 == null || data1 == "") return data2;
  return data1 + "&" + data2;
}

function partialload_startNextRequest() {
  var entry = partialload_queue[partialload_queueRPos++];
  var req = new XMLHttpRequest();
  req.open(entry.method, entry.url, true);
  req.onreadystatechange = function() {
    if (req.readyState == 4) {
      if (req.status == 200) {
        if (entry.successHandler != null) entry.successHandler(req.responseText);
      } else {
        if (entry.failureHandler != null) entry.failureHandler();
      }
      if (partialload_queue[partialload_queueRPos]) {
        partialload_startNextRequest();
      } else {
        partialload_queue = [];
        partialload_queueRPos = 0;
        partialload_queueWPos = 0;
      }
    }
  }
  if (entry.data) {
    req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  }
  req.send(entry.data);
}

function queuedHttpRequest(
  url_or_form,
  urlParams,
  postParams,
  successHandler,
  failureHandler
) {
  var method;
  var data = null;
  if (typeof(postParams) == "string") {
    data = postParams;
  } else if (postParams != null) {
    data = partialload_encodeFormData(postParams);
  }
  var url;
  if (typeof(url_or_form) == "object") {
    // form element given
    var form = url_or_form;
    url = partialload_addFormDataToUrl(form.action, urlParams);
    var dataFromForm = partialload_encodeFormData(
      partialload_getFormKeyValuePairs(form)
    );
    if (form.method != null && form.method.search(/^POST$/i) >= 0) {
      method = "POST";
      data = partialload_mergeEncodedFormData(data, dataFromForm);
    } else {
      method = (postParams == NULL) ? "GET" : "POST";
      url = partialload_addFormDataToUrl(url, dataFromForm);
    }
  } else {
    // URL given
    url = partialload_addFormDataToUrl(url_or_form, urlParams);
    if (postParams == null) {
      method = "GET";
    } else {
      method = "POST";
      if (typeof(postParams) == "string") {
	data = postParams;
      } else {
	data = partialload_encodeFormData(postParams);
      }
    }
  }
  partialload_queue[partialload_queueWPos++] = {
    method:         method,
    url:            url,
    data:           data,
    successHandler: successHandler,
    failureHandler: failureHandler
  };
  if (partialload_queueRPos == 0) {
    partialload_startNextRequest();
  }
}

function setHtmlContent(node, htmlWithScripts) {
  var uniquePrefix = "placeholder" + Math.floor(Math.random()*10e16) + "_";
  var i = 0;
  var scripts = [];
  var htmlWithPlaceholders = "";
  // NOTE: This function can not handle CDATA blocks at random positions.
  htmlWithPlaceholders = htmlWithScripts.replace(
    /<script[^>]*>(.*?)<\/script>/ig,
    function(all, inside) {
      scripts[i] = inside;
      var placeholder = '<span id="' + uniquePrefix + i + '"></span>';
      i++;
      return placeholder;
    }
  )
  node.innerHTML = htmlWithPlaceholders;
  var documentWriteBackup   = document.write;
  var documentWritelnBackup = document.writeln;
  var output;
  document.write   = function(str) { output += str; }
  document.writeln = function(str) { output += str + "\n"; }
  for (i=0; i<scripts.length; i++) {
    var placeholderNode = document.getElementById(uniquePrefix + i);
    output = "";
    eval(scripts[i]);
    if (output != "") {
      placeholderNode.innerHTML = output;
      while (placeholderNode.childNodes.length > 0) {
        var childNode = placeholderNode.childNodes[0];
        placeholderNode.removeChild(childNode);
        placeholderNode.parentNode.insertBefore(childNode, placeholderNode);
      }
    }
    placeholderNode.parentNode.removeChild(placeholderNode);
  }
  document.write   = documentWriteBackup;
  document.writeln = documentWritelnBackup;
}

function partialLoad(
  node,
  tempLoadingContent,
  failureContent,
  url_or_form,
  urlParams,
  postParams,
  successHandler,
  failureHandler
) {
  if (typeof(node) == "string") node = document.getElementById(node);
  if (tempLoadingContent != null) setHtmlContent(node, tempLoadingContent);
  queuedHttpRequest(
    url_or_form,
    urlParams,
    postParams,
    function(response) {
      setHtmlContent(node, response);
      if (successHandler != null) successHandler();
    },
    function() {
      if (failureContent != null) setHtmlContent(node, failureContent);
      if (failureHandler != null) failureHandler();
    }
  );
}

function partialMultiLoad(
  mapping,
  tempLoadingContents,
  failureContents,
  url_or_form,
  urlParams,
  postParams,
  successHandler,
  failureHandler
) {
  if (mapping instanceof Array) {
    var mappingHash = {}
    for (var i=0; i<mapping.length; i++) {
      mappingHash[mapping[i]] = mapping[i];
    }
    mapping = mappingHash;
  }
  if (typeof(tempLoadingContents) == "string") {
    for (var key in mapping) {
      var node = key;
      if (typeof(node) == "string") node = document.getElementById(node);
      setHtmlContent(node, tempLoadingContents);
    }
  } else if (tempLoadingContents != null) {
    for (var key in tempLoadingContents) {
      var node = key;
      if (typeof(node) == "string") node = document.getElementById(node);
      setHtmlContent(node, tempLoadingContents[key]);
    }
  }
  queuedHttpRequest(
    url_or_form,
    urlParams,
    postParams,
    function(response) {
      var data = eval("(" + response + ")");
      for (var key in mapping) {
        var node = key;
        if (typeof(node) == "string") node = document.getElementById(node);
        setHtmlContent(node, data[mapping[key]]);
      }
      if (successHandler != null) successHandler();
    },
    function() {
      if (typeof(failureContents) == "string") {
        for (var key in mapping) {
          var node = key;
          if (typeof(node) == "string") node = document.getElementById(node);
          setHtmlContent(node, failureContents);
        }
      } else if (failureContents != null) {
        for (var key in failureContents) {
          var node = key;
          if (typeof(node) == "string") node = document.getElementById(node);
          setHtmlContent(node, failureContents[key]);
        }
      }
      if (failureHandler != null) failureHandler();
    }
  );
}
