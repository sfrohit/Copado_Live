//setup before functions
var typingTimer;                //timer identifier
var doneTypingInterval = 500;
var branches = [];

/**
 * Method to fire once user stop writing
 */
function keyPressedOnLookup(componentId, repoId, attName, objectName, fieldNames, fieldsPattern, photo, objectPluralName, searchFunction, isSchema){
    console.log('key pressed');
    clearTimeout(typingTimer);
    var selector = '#'+componentId;
    console.log('selector',selector);
    if (document.querySelector(selector+" #lookup").value) {
        typingTimer = setTimeout(startSearch(componentId, repoId, attName), doneTypingInterval);
    } else{
        var searchText = document.querySelector(selector+" #lookup");
        var lstBox = document.querySelector(selector+" #list-box");
        lstBox.style.display = 'none';
    }
}
function addRefresh(componentId){
    showLoader(componentId);
    var selector = '#'+componentId;

    var lstBox = document.querySelector(selector+" #list-box");
    console.log('lstBox',lstBox);
    lstBox.style.display = 'block';

    var recordLst = document.querySelector(selector+" #record-list");
    recordLst.innerHTML = '';
    document.querySelector(selector+" #search-text-info").innerHTML = '"" in branches';
    recordLst.appendChild(createRecordLi(componentId,'Refresh Branches cache',true,'refreshBranchIcon'));
    if(branch && branch.applyRenderSVG) branch.applyRenderSVG([],['refreshBranchIcon','branchItemIcon']);
    hideLoader(componentId);
}
/**
 * Function to get users from servers to display for Reviewers
 */
function startSearch(componentId, repoId, attName) {
    var selector = '#'+componentId;
    console.log('componentId:::',componentId);
    showLoader(componentId);
    var searchText = document.querySelector(selector+" #lookup");

    var lstBox = document.querySelector(selector+" #list-box");
    console.log('lstBox',lstBox);
    lstBox.style.display = 'block';

    var recordLst = document.querySelector(selector+" #record-list");
    recordLst.innerHTML = '';
    var q = "Select Id, Body, LastModifiedDate, Name, ParentId From Attachment where Name='" + attName + "' and parentId = '" + repoId + "' order by LastModifiedDate DESC limit 1";
    var result = sforce.connection.query(q);
    var records = result.getArray("records");
    var res = Base64.decode(records[0].Body);
    var cacheDate = records[0].LastModifiedDate;
    branches = $copado.parseJSON(res);

    if (branches.length > 0) {
        for(var i = 0; i < branches.length ; i++){
            var record = branches[i].name;
            if(record.indexOf(searchText.value) > -1)
            recordLst.appendChild(createRecordLi(componentId,record,true,'branchItemIcon'));
        }
        document.querySelector(selector+" #search-text-info").innerHTML = '"'+searchText.value + '" in branches';
        recordLst.appendChild(createRecordLi(componentId,'Refresh Branches cache',true,'refreshBranchIcon'));
        if(branch && branch.applyRenderSVG) branch.applyRenderSVG([],['refreshBranchIcon','branchItemIcon']);
        hideLoader(componentId);
    } else {
        document.querySelector(selector+" #search-text-info").innerHTML = '"" in branches';
        recordLst.appendChild(createRecordLi(componentId,'Refresh Branches cache',true,'refreshBranchIcon'));
        if(branch && branch.applyRenderSVG) branch.applyRenderSVG([],['refreshBranchIcon','branchItemIcon']);
        hideLoader(componentId);
    }

}

/**
 * Create li for every record to display
 * @param  user
 * @return li
 */
function createRecordLi(componentId,branch,showSVG,svgClass){
    var id = branch;
    var displayName = branch;
    var li = document.createElement("li");
    li.setAttribute("class", "slds-lookup__item");
    li.setAttribute("onclick", "select('"+componentId+"', '"+displayName+"', '"+id+"')");
    var inner;
    if(showSVG){
        inner = '<div style="display:inline-block;padding-left:15px;padding-right:5px;width: 100%;position: relative;" class="slds-icon slds-icon-text-default slds-icon__small ';
        inner += svgClass;
        inner +='  slds-button__icon" ><a style="color:black;padding-left:15px;" id=s02 role=option>';
        inner += displayName;
        inner += '</a></div>';
    } else {
        inner = '<a tyle="color:black;padding-left:15px;" id=s02 role=option>';
        inner += displayName;
        inner += '</a>';
    }


    li.innerHTML = inner;
    return li;
}

function select(componentId, name){
    //TODO
    var selector = '#'+componentId;
    showLoader(componentId);
    document.querySelector(selector+" #selected-name").innerHTML = name;
//    eval(componentId+"setOwnerId('"+id+"')");
    recordSelected(componentId);
}

/**
 * User selected function
 * @return {[type]} [description]
 */
function recordSelected(componentId){
    var selector = '#'+componentId;
    if(document.querySelector(selector+" #selected-record").style.display == 'none'){
        document.querySelector(selector+" #selected-record").style.display = 'block';
        document.querySelector(selector+" #input-text").style.display = 'none';
        document.querySelector(selector+" #lookup").value = '';
        var lstBox = document.querySelector(selector+" #list-box");
        lstBox.style.display = 'none';
    }else{
        document.querySelector(selector+" #input-text").style.display = 'block';
        document.querySelector(selector+" #selected-record").style.display = 'none';
    }
    hideLoader(componentId);
}
function removeSelected(componentId){
    var selector = '#'+componentId;
    if(document.querySelector(selector+" #selected-record").style.display == 'block'){
        document.querySelector(selector+" #selected-record").style.display = 'none';
        document.querySelector(selector+" #input-text").style.display = 'block';
        document.querySelector(selector+" #lookup").value = '';
        var lstBox = document.querySelector(selector+" #list-box");
        lstBox.style.display = 'block';
    }else{
        document.querySelector(selector+" #input-text").style.display = 'block';
        document.querySelector(selector+" #selected-record").style.display = 'none';
    }
    hideLoader(componentId);
}

/**
 * remove selected record
 * @return {[type]} [description]
 */
function removeRecord(componentId){
    var selector = '#'+componentId;
    document.querySelector(selector+" #selected-name").innerHTML = '';
    recordSelected(componentId);
}

function showLoader(componentId){
    var selector = '#'+componentId;
    document.querySelector(selector+" #loader").style.display = 'block';
}

function hideLoader(componentId){
    var selector = '#'+componentId;
    document.querySelector(selector+" #loader").style.display = 'none';
}