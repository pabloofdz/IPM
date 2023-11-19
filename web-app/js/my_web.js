//JavaScript 1.5

function selectedImage(image) {
    if (image == 'Picture-1')
        return "img1";
    if (image == 'Picture-2')
        return "img2";
    return "img3";           
}

function altImage(imgStr) {
    if (imgStr == "img1")
        return "Image of a tuna";
    else if (imgStr == "img2")
        return "Image of a bonito del norte";
    else
        return "Image of a cat";
}

document.querySelector("form").addEventListener('submit', function (event){
    let name=document.getElementById("name").value;
    let date=document.getElementById("date").value;
    let number=document.getElementById("number").value;
    let bonito=document.getElementById("bonito").value;
    var list=document.getElementById('list');
    var entry=document.createElement('li');
    var imgNumber=selectedImage(bonito); //Selected image  
    let img=document.getElementById(imgNumber);
    var copyImage=img.cloneNode();
    copyImage.alt=altImage(imgNumber);
    var span=document.createElement('span');
    span.appendChild(document.createTextNode('Name: '+name)); //This line insert a text
    entry.appendChild(span);
    var span2=document.createElement('span');
    span2.appendChild(document.createTextNode('Date: '+date)); //This line insert a text
    entry.appendChild(span2);
    var span3=document.createElement('span');
    span3.appendChild(document.createTextNode('Number: '+number)); //This line insert a text
    entry.appendChild(span3);
    entry.appendChild(copyImage); //This line insert an image
    list.appendChild(entry);
    document.getElementById("name").value="";
    document.getElementById("date").value="";
    document.getElementById("number").value="";
    document.getElementById("bonito").value="";
    event.preventDefault();
});