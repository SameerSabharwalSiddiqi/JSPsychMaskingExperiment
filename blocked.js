<!DOCTYPE html>
<html>
    <head>
        <script src = "jspsych/jspsych.js"></script>
        <script src = "jspsych/plugins/jspsych-html-keyboard-response.js"></script>
        <script src = "jspsych/plugins/jspsych-image-keyboard-response.js"></script>
        <script src = "jspsych/plugins/jspsych-html-button-response.js"></script>
        <script src = "jspsych/plugins/jspsych-survey-text.js"></script>
        <script src = "jspsych/plugins/jspsych-image-button-response.js"></script>
        <script src = "jspsych/plugins/jspsych-html-button-response.js"></script>
        <script src = "jspsych/plugins/jspsych-video-button-response.js"></script>
        <script src = "jspsych/plugins/jspsych-fullscreen.js"></script>
        <script src = "jspsych/plugins/jspsych-html-slider-response.js"></script>
        <link href = "jspsych/css/jspsych.css" rel = "stylesheet">
    </head>
    <body></body>
    <script>
var isFirefox = typeof InstallTrigger !== 'undefined'
//Part1: The initial Memory Phase 
    var nPracticeFaceNamesForEachGender = 4 //just for practice section
        practiceMinimumFaceNames = nPracticeFaceNamesForEachGender// nPracticeFaceNamesForEachGender
    var minimumFaceNamesForEachGender = 64 //sets the minimum number of faces per gender for the initial MEMORIZATION phase. The total number of faces (both genders), is 2x this number
        minimumFaceNames = minimumFaceNamesForEachGender //just to make the variable's definition more explicit up here, and more concise in the actual body of code
    postCalibrationTrials = 50 //Number of trials in which we ask the subject if she saw a "disgust" face
    ITIDurationRecall = 500     //Default = 500
    PresentationDuration = 5000//Default = 5000
    nMemorizationTrials = (minimumFaceNames*2)//(minimumFaceNames*2) //Default: (minimumFaceNames*2)
        nPracticeMemorizationTrials = (practiceMinimumFaceNames*2)
    //Part2: Recall/Masked-Affective Phase
    nTrialsRecall = (minimumFaceNames*2) //Default: (minimumFaceNames*2)-2
        nPracticeRecallTrials = (practiceMinimumFaceNames*2)
    lastTrial = nTrialsRecall-1 //bc iterator starts from 0 (see for loop below)
    ITIDuration= 1000 //default = 1000
    forwardMaskDuration = 250 //default = 250
    cueDuration = 16 //Include brackets! default = [16]. For variable durations, enter an array (e.g., [16,33,66])
    backwardMaskDuration = 100 //default = 100
    fixationDuration = 1000 //default = 200
    disgustKey = 'd'// When changing, change in prompt for test-phase as well!
    neutralKey = 'n'// When changing, change in prompt for test-phase as well!
    
    //Loading Functions
    //Function 1: Shuffling Array
    //shuffle the associative array - this is mainly just to ensure that male/female pairs are mixed
    function shuffle(array) {
        var currentIndex = array.length, temporaryValue, randomIndex;
        while (0 !== currentIndex) {
        randomIndex = Math.floor(Math.random() * currentIndex);
        currentIndex -= 1;
        temporaryValue = array[currentIndex];
        array[currentIndex] = array[randomIndex];
        array[randomIndex] = temporaryValue;
  }
  return array;
    }
    //function2: get random integer
    function getRandomInt(min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min) + min); //The maximum is exclusive and the minimum is inclusive
        }

    //Function3: Return 1 if number is even (including 0)
    function isEven(value){
    if (value%2 == 0)
        return 1;
    else
        return 0;
    }

    //Array Reverse function -- Use convention ->: reverseArray(arrayname)    -Tristan :)
    function reverseArray(arr) {
        var newArray = [];
        for (var i = arr.length - 1; i >= 0; i--) {
            newArray.push(arr[i])
        }
        return newArray;
    }

    //creating arrays for face-name pairs, and also making sure all arrays are the same length 
    var maleNameArray = ["Antonio","Patrick","Marcus","Samuel","Carlos","William","Andrew","Corey","Jared","Evan","Mark","Vincent","Jesse","Travis","Kenneth","Steven","Jeremy","Jacob","Ryan","Dustin","Cameron","Sean","Timothy","Luis","Austin","Justin","Kevin","Tyler","Christopher","Shawn","Paul","David","Edward","Aaron","Michael","Cory","Zachary","Thomas","Shane","Bradley","Cody","John","Adam","Chad","Jordan","Jonathan","George","Jose","Stephen","Keith","Taylor","Nathan","Joseph","Scott","Anthony","Derek","Charles","Kyle","Benjamin","Alex","Phillip","Joshua","Brandon","Eric","Jason","Gregory","Juan","Daniel","Robert","James","Nicholas","Jeffrey","Peter","Richard","Ian","Christian","Brian","Matthew"];
    var femaleNameArray = ["Anna","Michelle","Emily","Kayla","Kimberly","Meghan","Elizabeth","Stephanie","Ashley","Vanessa","Victoria","Samantha","Christina","Julie","Amanda","Brittany","Andrea","Kelsey","Maria","Alicia","Courtney","Alexandra","Sarah","Amber","Jennifer","Allison","Morgan","Erika","Nicole","Jessica","Kristen","April","Kelly","Katie","Monica","Crystal","Danielle","Natalie","Jamie","Mary","Jacqueline","Chelsea","Brooke","Catherine","Hannah","Holly","Brianna","Caitlin","Rachel","Rebecca","Laura","Heather","Erin","Lindsey","Angela","Tiffany","Jasmine","Whitney","Jenna","Amy","Jordan","Taylor","Lauren","Melissa","Sara","Megan","Katelyn","Tara","Cassandra","Shannon","Lisa"];
    var femaleFaceArray = ['CFD-AF-200-228-N.jpg','CFD-AF-201-060-N.jpg','CFD-AF-203-077-N.jpg','CFD-AF-208-003-N.jpg','CFD-AF-209-006-N.jpg','CFD-AF-214-139-N.jpg','CFD-AF-215-70-N.jpg','CFD-AF-220-107-N.jpg','CFD-AF-222-134-N.jpg','CFD-AF-226-251-N.jpg','CFD-AF-228-173-N.jpg','CFD-AF-230-193-N.jpg','CFD-AF-233-190-N.jpg','CFD-AF-235-170-N.jpg','CFD-AF-237-223-N.jpg','CFD-AF-239-171-N.jpg','CFD-AF-240-206-N.jpg','CFD-AF-241-141-N.jpg','CFD-AF-242-158-N.jpg','CFD-AF-243-170-N.jpg','CFD-BF-001-025-N.jpg','CFD-BF-004-014-N.jpg','CFD-BF-005-001-N.jpg','CFD-BF-008-001-N.jpg','CFD-BF-009-002-N.jpg','CFD-BF-010-001-N.jpg','CFD-BF-016-017-N.jpg','CFD-BF-019-001-N.jpg','CFD-BF-021-013-N.jpg','CFD-BF-023-010-N.jpg','CFD-BF-025-002-N.jpg','CFD-BF-039-031-N.jpg','CFD-BF-047-003-N.jpg','CFD-BF-201-080-N.jpg','CFD-BF-209-172-N.jpg','CFD-BF-212-315-N.jpg','CFD-BF-218-207-N.jpg','CFD-BF-221-223-N.jpg','CFD-BF-222-240-N.jpg','CFD-BF-226-119-N.jpg','CFD-LF-200-058-N.jpg','CFD-LF-201-035-N.jpg','CFD-LF-202-065-N.jpg','CFD-LF-203-066-N.jpg','CFD-LF-204-133-N.jpg','CFD-LF-205-100-N.jpg','CFD-LF-206-078-N.jpg','CFD-LF-208-127-N.jpg','CFD-LF-210-220-N.jpg','CFD-LF-213-079-N.jpg','CFD-LF-215-157-N.jpg','CFD-LF-218-072-N.jpg','CFD-LF-220-120-N.jpg','CFD-LF-230-203-N.jpg','CFD-LF-231-260-N.jpg','CFD-LF-232-199-N.jpg','CFD-LF-236-221-N.jpg','CFD-LF-239-148-N.jpg','CFD-LF-243-175-N.jpg','CFD-LF-244-096-N.jpg','CFD-WF-003-003-N.jpg','CFD-WF-006-002-N.jpg','CFD-WF-016-015-N.jpg','CFD-WF-017-003-N.jpg','CFD-WF-018-017-N.jpg','CFD-WF-019-005-N.jpg','CFD-WF-023-003-N.jpg','CFD-WF-024-003-N.jpg','CFD-WF-029-002-N.jpg','CFD-WF-038-021-N.jpg','CFD-WF-200-099-N.jpg','CFD-WF-202-056-N.jpg','CFD-WF-204-038-N.jpg','CFD-WF-205-006-N.jpg','CFD-WF-207-014-N.jpg','CFD-WF-215-145-N.jpg','CFD-WF-217-085-N.jpg','CFD-WF-218-087-N.jpg','CFD-WF-220-101-N.jpg','CFD-WF-223-133-N.jpg']
    var maleFaceArray = ['CFD-AM-202-079-N.jpg','CFD-AM-205-153-N.jpg','CFD-AM-207-108-N.jpg','CFD-AM-211-052-N.jpg','CFD-AM-212-050-N.jpg','CFD-AM-213-056-N.jpg','CFD-AM-214-168-N.jpg','CFD-AM-220-134-N.jpg','CFD-AM-221-184-N.jpg','CFD-AM-228-214-N.jpg','CFD-AM-229-224-N.jpg','CFD-AM-230-150-N.jpg','CFD-AM-231-136-N.jpg','CFD-AM-234-355-N.jpg','CFD-AM-237-154-N.jpg','CFD-AM-238-269-N.jpg','CFD-AM-242-176-N.jpg','CFD-AM-243-212-N.jpg','CFD-AM-246-184-N.jpg','CFD-AM-248-104-N.jpg','CFD-BM-001-014-N.jpg','CFD-BM-002-013-N.jpg','CFD-BM-010-003-N.jpg','CFD-BM-011-016-N.jpg','CFD-BM-017-021-N.jpg','CFD-BM-018-001-N.jpg','CFD-BM-022-022-N.jpg','CFD-BM-026-002-N.jpg','CFD-BM-027-001-N.jpg','CFD-BM-029-024-N.jpg','CFD-BM-032-024-N.jpg','CFD-BM-039-029-N.jpg','CFD-BM-041-035-N.jpg','CFD-BM-043-071-N.jpg','CFD-BM-203-001-N.jpg','CFD-BM-205-001-N.jpg','CFD-BM-207-024-N.jpg','CFD-BM-208-065-N.jpg','CFD-BM-210-148-N.jpg','CFD-BM-211-174-N.jpg','CFD-LM-200-045-N.jpg','CFD-LM-201-057-N.jpg','CFD-LM-209-111-N.jpg','CFD-LM-213-061-N.jpg','CFD-LM-217-162-N.jpg','CFD-LM-219-295-N.jpg','CFD-LM-220-329-N.jpg','CFD-LM-221-216-N.jpg','CFD-LM-223-175-N.jpg','CFD-LM-224-162-N.jpg','CFD-LM-225-130-N.jpg','CFD-LM-233-171-N.jpg','CFD-LM-234-176-N.jpg','CFD-LM-239-075-N.jpg','CFD-LM-246-087-N.jpg','CFD-LM-248-089-N.jpg','CFD-LM-252-076-N.jpg','CFD-WM-003-002-N.jpg','CFD-WM-006-002-N.jpg','CFD-WM-009-002-N.jpg','CFD-WM-011-002-N.jpg','CFD-WM-015-002-N.jpg','CFD-WM-017-002-N.jpg','CFD-WM-019-003-N.jpg','CFD-WM-020-001-N.jpg','CFD-WM-022-001-N.jpg','CFD-WM-032-001-N.jpg','CFD-WM-034-030-N.jpg','CFD-WM-041-021-N.jpg','CFD-WM-207-048-N.jpg','CFD-WM-212-097-N.jpg','CFD-WM-213-076-N.jpg','CFD-WM-215-041-N.jpg','CFD-WM-216-061-N.jpg','CFD-WM-222-057-N.jpg','CFD-WM-232-070-N.jpg','CFD-WM-237-052-N.jpg']

    
    var maleNameLength = maleNameArray.length
    var femaleNameLength = femaleNameArray.length
    var maleFaceLength = maleFaceArray.length
    var femaleFaceLength = femaleFaceArray.length

    //for 12/24/2020 version, there should be 177 total faces. But note that memorize only 128 faces
    //Therefore, just use 64 for the minimum faces (as shown to below, to abridge the arrays)
    //var minimumFaceNames = Math.min(maleNameLength,femaleNameLength,maleFaceLength,femaleFaceLength)

    //For practice question, we will access face/names from the ENDs of the arrays, so as to not overlap face/names with the actual ones used in the test-phase
    var flippedArray = maleNameArray.reverse()
    
    practiceMaleNameArray= reverseArray(maleNameArray)
    practiceFemaleNameArray = reverseArray(femaleNameArray)
    practiceMaleFaceArray = reverseArray(maleFaceArray)
    practiceFemaleFaceArray = reverseArray(femaleFaceArray)

    if(maleNameLength > minimumFaceNames){
    var maleNameArray = maleNameArray.slice(1,minimumFaceNames+1)
    var practiceMaleNameArray = practiceMaleNameArray.slice(1,practiceMinimumFaceNames+1)
    }
    if(femaleNameLength > minimumFaceNames){
    var femaleNameArray = femaleNameArray.slice(1,minimumFaceNames+1)
    var practiceFemaleNameArray = practiceFemaleNameArray.slice(1,practiceMinimumFaceNames+1)

    }
    if(maleFaceLength > minimumFaceNames){
    var maleFaceArray = maleFaceArray.slice(1,minimumFaceNames+1)
    var practiceMaleFaceArray = practiceMaleFaceArray.slice(1,practiceMinimumFaceNames+1)
    }

    if(femaleFaceLength > minimumFaceNames){
    var femaleFaceArray = femaleFaceArray.slice(1,minimumFaceNames+1)
    var practiceFemaleFaceArray = practiceFemaleFaceArray.slice(1,practiceMinimumFaceNames+1)
    }
    //Now, anticipating the Test phase of the experiment (w/ NON-INTACT face-name paris), let's create two more name arrays with different orientation
    var rearrangedMaleNameArray= []
    var rearrangedFemaleNameArray = []
    var rearrangedMaleNamePracticeArray = []
    var rearrangedFemaleNamePracticeArray =[]
    for(var i=0;i<minimumFaceNames;i++){
        let lastIndex = minimumFaceNames-1;
        if(i==0){
            rearrangedMaleNameArray[i]=maleNameArray[lastIndex-1]
            rearrangedFemaleNameArray[i]=femaleNameArray[lastIndex-1]
        }
        if(i==1){
            rearrangedMaleNameArray[i]=maleNameArray[lastIndex]
            rearrangedFemaleNameArray[i]=femaleNameArray[lastIndex]

        }
        if(i>1){
            rearrangedMaleNameArray[i]=maleNameArray[i-2]
            rearrangedFemaleNameArray[i]=femaleNameArray[i-2]
        }}

    for(var i=1;i<nPracticeFaceNamesForEachGender;i++){
        let lastPracticeIndex = practiceMinimumFaceNames-1
        if(i==0){
            rearrangedMaleNamePracticeArray[i]= practiceMaleNameArray[lastPracticeIndex-1]
            rearrangedFemaleNamePracticeArray[i] = practiceFemaleNameArray[lastPracticeIndex-1]
        }
        if(i==1){
            rearrangedMaleNamePracticeArray[i]= practiceMaleNameArray[lastPracticeIndex]
            rearrangedFemaleNamePracticeArray[i] = practiceFemaleNameArray[lastPracticeIndex]
        }
        if(i>1){
            rearrangedMaleNamePracticeArray[i]= practiceMaleNameArray[i-2]
            rearrangedFemaleNamePracticeArray[i] = practiceFemaleNameArray[i-2]
        }}
    
    var nameArraysAreUnique = 1 //double-check
    for(var i = 0; i< minimumFaceNames;i++){
    let nameIntact = maleNameArray[i]
    let nameRearranged = rearrangedMaleNameArray[i]
    if(nameIntact=nameRearranged){nameArraysAreUnique=0}
    }

    var maleFirstAllNames = maleNameArray.concat(femaleNameArray)
    var maleFirstAllFaces = maleFaceArray.concat(femaleFaceArray)
    var maleFirstRearrangedNames = rearrangedMaleNameArray.concat(rearrangedFemaleNameArray)

    var maleFirstAllPracticeNames = practiceMaleNameArray.concat(practiceFemaleNameArray)
    var maleFirstAllPracticeFaces = practiceMaleFaceArray.concat(practiceFemaleFaceArray)
    var maleFirstRearrangedPracticeNames = rearrangedMaleNamePracticeArray.concat(rearrangedFemaleNamePracticeArray)

    var nameArraysAreUnique = 1 //for below check, if 0 it means that one of the names in the rearranged array is not in fact switched in terms of its position
    //...which would lead to an INTACT face being labelled as REARRANGED (problem)
    
    //order all faces and names in an associative array. Will make scrambling easier - and specifically such
    //gender pairings are preserved after scrambling order (i.e., no male faces with female names)
    var faceNamePairs = [];
    var rearrangedFaceNamePairs = [];
    for (var i=0; i<(minimumFaceNames*2); i++) {
    faceNamePairs[i] = {
        name: maleFirstAllNames[i],
        face: maleFirstAllFaces[i],
        rearranged: 0}
    rearrangedFaceNamePairs[i] ={
        name: maleFirstRearrangedNames[i],
        face: maleFirstAllFaces[i],
        rearranged: 1}
    };

    var faceNamePairsPractice = []
    var rearrangedFaceNamePairsPractice = []
    for(var i =0;i <(practiceMinimumFaceNames*2); i++){
        faceNamePairsPractice[i] = {
            name: maleFirstAllPracticeNames[i],
            face: maleFirstAllPracticeFaces[i],
            rearranged: 0}
            rearrangedFaceNamePairsPractice[i]={
            name:maleFirstRearrangedPracticeNames[i],
            face: maleFirstAllPracticeFaces[i],
            rearranged: 0}
        }

//  See PP (12242020MemoryAssociation Flowchart) for proof that this odd/even strategy works
var hybridArray = [];
var lastTrial = minimumFaceNames*2-1
for (var i=0; i<(minimumFaceNames*2); i++) {
    if(isEven(i)){
        hybridArray[i] = {
            name: faceNamePairs[i].name,
            face: faceNamePairs[i].face,
            rearranged: 0}
        } else {
        hybridArray[i] = {
            name: rearrangedFaceNamePairs[i].name,
            face: rearrangedFaceNamePairs[i].face,
            rearranged: 1}}}


var hybridPracticeArray = [];
var lastPracticeTrial = practiceMinimumFaceNames*2-1
for (var i =0; i<(practiceMinimumFaceNames*2);i++){
    if(isEven(i)){
        hybridPracticeArray[i] = {
            name: faceNamePairsPractice[i].name,
            face: faceNamePairsPractice[i].face,
            rearranged: 0}
        } else {
            hybridPracticeArray[i]={
                name: rearrangedFaceNamePairsPractice[i].name,
                face: rearrangedFaceNamePairsPractice[i].face,
                rearranged: 1}
            }
        }
    

//Now do a final shuffle to ensure that male and female faces are interspersed 
var hybridArray = shuffle(hybridArray)
var faceNamePairs = shuffle(faceNamePairs)
var faceNamePairsPractice = shuffle(faceNamePairsPractice)
var hybridPracticeArray = shuffle(hybridPracticeArray)
        //don't bother shuffling the practice array


////////////////////////////  Creation of "PreloadedMaskArray" ///////////////////////////////////
        //Loop through a fleixble number of trials
        var preloadedMaskImages = []
        var neutralFacesArrFemale= ['AF01NES.JPG', 'AF02NES.JPG', 'AF03NES.JPG', 'AF04NES.JPG', 'AF05NES.JPG', 'AF06NES.JPG', 'AF07NES.JPG', 'AF08NES.JPG', 'AF09NES.JPG', 'AF10NES.JPG', 'AF11NES.JPG', 'AF12NES.JPG', 'AF13NES.JPG', 'AF14NES.JPG', 'AF15NES.JPG', 'AF16NES.JPG', 'AF17NES.JPG', 'AF18NES.JPG', 'AF19NES.JPG', 'AF20NES.JPG', 'AF21NES.JPG', 'AF22NES.JPG', 'AF23NES.JPG', 'AF24NES.JPG', 'AF25NES.JPG', 'AF26NES.JPG', 'AF27NES.JPG', 'AF28NES.JPG', 'AF29NES.JPG', 'AF30NES.JPG', 'AF31NES.JPG', 'AF32NES.JPG', 'AF33NES.JPG', 'AF34NES.JPG', 'AF35NES.JPG','BF01NES.JPG', 'BF02NES.JPG', 'BF03NES.JPG', 'BF04NES.JPG', 'BF05NES.JPG', 'BF06NES.JPG', 'BF07NES.JPG', 'BF08NES.JPG', 'BF09NES.JPG', 'BF10NES.JPG', 'BF11NES.JPG', 'BF12NES.JPG', 'BF13NES.JPG', 'BF14NES.JPG', 'BF15NES.JPG', 'BF16NES.JPG', 'BF17NES.JPG', 'BF18NES.JPG', 'BF19NES.JPG', 'BF20NES.JPG', 'BF21NES.JPG', 'BF22NES.JPG', 'BF23NES.JPG', 'BF24NES.JPG', 'BF25NES.JPG', 'BF26NES.JPG', 'BF27NES.JPG', 'BF28NES.JPG', 'BF29NES.JPG', 'BF30NES.JPG', 'BF31NES.JPG', 'BF32NES.JPG', 'BF33NES.JPG', 'BF34NES.JPG', 'BF35NES.JPG']
        var neutralFacesArrMale = ['AM01NES.JPG', 'AM02NES.JPG', 'AM03NES.JPG', 'AM04NES.JPG', 'AM05NES.JPG', 'AM06NES.JPG', 'AM07NES.JPG', 'AM08NES.JPG', 'AM09NES.JPG', 'AM10NES.JPG', 'AM11NES.JPG', 'AM13NES.JPG', 'AM14NES.JPG', 'AM15NES.JPG', 'AM17NES.JPG', 'AM18NES.JPG', 'AM21NES.JPG', 'AM22NES.JPG', 'AM23NES.JPG', 'AM25NES.JPG', 'AM26NES.JPG', 'AM27NES.JPG', 'AM28NES.JPG', 'AM29NES.JPG', 'AM30NES.JPG', 'AM31NES.JPG', 'AM32NES.JPG', 'AM33NES.JPG', 'AM34NES.JPG', 'AM35NES.JPG','BM01NES.JPG', 'BM02NES.JPG', 'BM03NES.JPG', 'BM04NES.JPG', 'BM05NES.JPG', 'BM06NES.JPG', 'BM07NES.JPG', 'BM08NES.JPG', 'BM09NES.JPG', 'BM10NES.JPG', 'BM11NES.JPG', 'BM12NES.JPG', 'BM13NES.JPG', 'BM14NES.JPG', 'BM16NES.JPG', 'BM21NES.JPG', 'BM22NES.JPG', 'BM23NES.JPG', 'BM24NES.JPG', 'BM25NES.JPG', 'BM26NES.JPG', 'BM27NES.JPG', 'BM28NES.JPG', 'BM30NES.JPG', 'BM31NES.JPG', 'BM32NES.JPG', 'BM33NES.JPG', 'BM34NES.JPG', 'BM35NES.JPG']
        var neutralFacesFemaleLength = neutralFacesArrFemale.length
        var neutralFacesMaleLength = neutralFacesArrMale.length

        var scrambledNeutralFacesArrFemale = ['scrambledAF01NES.JPG', 'scrambledAF02NES.JPG', 'scrambledAF03NES.JPG', 'scrambledAF04NES.JPG', 'scrambledAF05NES.JPG', 'scrambledAF06NES.JPG', 'scrambledAF07NES.JPG', 'scrambledAF08NES.JPG', 'scrambledAF09NES.JPG', 'scrambledAF10NES.JPG', 'scrambledAF11NES.JPG', 'scrambledAF12NES.JPG', 'scrambledAF13NES.JPG', 'scrambledAF14NES.JPG', 'scrambledAF15NES.JPG', 'scrambledAF16NES.JPG', 'scrambledAF17NES.JPG', 'scrambledAF18NES.JPG', 'scrambledAF19NES.JPG', 'scrambledAF20NES.JPG', 'scrambledAF21NES.JPG', 'scrambledAF22NES.JPG', 'scrambledAF23NES.JPG', 'scrambledAF24NES.JPG', 'scrambledAF25NES.JPG', 'scrambledAF26NES.JPG', 'scrambledAF27NES.JPG', 'scrambledAF28NES.JPG', 'scrambledAF29NES.JPG', 'scrambledAF30NES.JPG', 'scrambledAF31NES.JPG', 'scrambledAF32NES.JPG', 'scrambledAF33NES.JPG', 'scrambledAF34NES.JPG', 'scrambledAF35NES.JPG','scrambledBF01NES.JPG', 'scrambledBF02NES.JPG', 'scrambledBF03NES.JPG', 'scrambledBF04NES.JPG', 'scrambledBF05NES.JPG', 'scrambledBF06NES.JPG', 'scrambledBF07NES.JPG', 'scrambledBF08NES.JPG', 'scrambledBF09NES.JPG', 'scrambledBF10NES.JPG', 'scrambledBF11NES.JPG', 'scrambledBF12NES.JPG', 'scrambledBF13NES.JPG', 'scrambledBF14NES.JPG', 'scrambledBF15NES.JPG', 'scrambledBF16NES.JPG', 'scrambledBF17NES.JPG', 'scrambledBF18NES.JPG', 'scrambledBF19NES.JPG', 'scrambledBF20NES.JPG', 'scrambledBF21NES.JPG', 'scrambledBF22NES.JPG', 'scrambledBF23NES.JPG', 'scrambledBF24NES.JPG', 'scrambledBF25NES.JPG', 'scrambledBF26NES.JPG', 'scrambledBF27NES.JPG', 'scrambledBF28NES.JPG', 'scrambledBF29NES.JPG', 'scrambledBF30NES.JPG', 'scrambledBF31NES.JPG', 'scrambledBF32NES.JPG', 'scrambledBF33NES.JPG', 'scrambledBF34NES.JPG', 'scrambledBF35NES.JPG'] 
        var scrambledNeutralFacesArrMale = ['scrambledAM01NES.JPG', 'scrambledAM02NES.JPG', 'scrambledAM03NES.JPG', 'scrambledAM04NES.JPG', 'scrambledAM05NES.JPG', 'scrambledAM06NES.JPG', 'scrambledAM07NES.JPG', 'scrambledAM08NES.JPG', 'scrambledAM09NES.JPG', 'scrambledAM10NES.JPG', 'scrambledAM11NES.JPG', 'scrambledAM13NES.JPG', 'scrambledAM14NES.JPG', 'scrambledAM15NES.JPG', 'scrambledAM17NES.JPG', 'scrambledAM18NES.JPG', 'scrambledAM21NES.JPG', 'scrambledAM22NES.JPG', 'scrambledAM23NES.JPG', 'scrambledAM25NES.JPG', 'scrambledAM26NES.JPG', 'scrambledAM27NES.JPG', 'scrambledAM28NES.JPG', 'scrambledAM29NES.JPG', 'scrambledAM30NES.JPG', 'scrambledAM31NES.JPG', 'scrambledAM32NES.JPG', 'scrambledAM33NES.JPG', 'scrambledAM34NES.JPG', 'scrambledAM35NES.JPG','scrambledBM01NES.JPG', 'scrambledBM02NES.JPG', 'scrambledBM03NES.JPG', 'scrambledBM04NES.JPG', 'scrambledBM05NES.JPG', 'scrambledBM06NES.JPG', 'scrambledBM07NES.JPG', 'scrambledBM08NES.JPG', 'scrambledBM09NES.JPG', 'scrambledBM10NES.JPG', 'scrambledBM11NES.JPG', 'scrambledBM12NES.JPG', 'scrambledBM13NES.JPG', 'scrambledBM14NES.JPG', 'scrambledBM16NES.JPG', 'scrambledBM21NES.JPG', 'scrambledBM22NES.JPG', 'scrambledBM23NES.JPG', 'scrambledBM24NES.JPG', 'scrambledBM25NES.JPG', 'scrambledBM26NES.JPG', 'scrambledBM27NES.JPG', 'scrambledBM28NES.JPG', 'scrambledBM30NES.JPG', 'scrambledBM31NES.JPG', 'scrambledBM32NES.JPG', 'scrambledBM33NES.JPG', 'scrambledBM34NES.JPG', 'scrambledBM35NES.JPG']
        
        
        var disgustFacesArrFemale = ['AF01DIS.JPG', 'AF02DIS.JPG', 'AF03DIS.JPG', 'AF04DIS.JPG', 'AF05DIS.JPG', 'AF06DIS.JPG', 'AF07DIS.JPG', 'AF09DIS.JPG', 'AF10DIS.JPG', 'AF11DIS.JPG', 'AF12DIS.JPG', 'AF13DIS.JPG', 'AF14DIS.JPG', 'AF15DIS.JPG', 'AF16DIS.JPG', 'AF17DIS.JPG', 'AF19DIS.JPG', 'AF20DIS.JPG', 'AF21DIS.JPG', 'AF22DIS.JPG', 'AF23DIS.JPG', 'AF24DIS.JPG', 'AF25DIS.JPG', 'AF26DIS.JPG', 'AF27DIS.JPG', 'AF28DIS.JPG', 'AF29DIS.JPG', 'AF30DIS.JPG', 'AF31DIS.JPG', 'AF32DIS.JPG', 'AF33DIS.JPG', 'AF34DIS.JPG', 'AF35DIS.JPG','BF01DIS.JPG', 'BF02DIS.JPG', 'BF03DIS.JPG', 'BF04DIS.JPG', 'BF05DIS.JPG', 'BF06DIS.JPG', 'BF07DIS.JPG', 'BF09DIS.JPG', 'BF10DIS.JPG', 'BF11DIS.JPG', 'BF12DIS.JPG', 'BF13DIS.JPG', 'BF14DIS.JPG', 'BF15DIS.JPG', 'BF16DIS.JPG', 'BF17DIS.JPG', 'BF19DIS.JPG', 'BF20DIS.JPG', 'BF21DIS.JPG', 'BF22DIS.JPG', 'BF23DIS.JPG', 'BF24DIS.JPG', 'BF25DIS.JPG', 'BF26DIS.JPG', 'BF27DIS.JPG', 'BF28DIS.JPG', 'BF29DIS.JPG', 'BF30DIS.JPG', 'BF31DIS.JPG', 'BF32DIS.JPG', 'BF33DIS.JPG', 'BF34DIS.JPG', 'BF35DIS.JPG', 'BM02DIS.JPG'] 
        var disgustFacesArrMale = ['AM01DIS.JPG', 'AM02DIS.JPG', 'AM03DIS.JPG', 'AM04DIS.JPG', 'AM05DIS.JPG', 'AM06DIS.JPG', 'AM07DIS.JPG', 'AM08DIS.JPG', 'AM09DIS.JPG', 'AM10DIS.JPG', 'AM11DIS.JPG', 'AM12DIS.JPG', 'AM13DIS.JPG', 'AM14DIS.JPG', 'AM15DIS.JPG', 'AM16DIS.JPG', 'AM17DIS.JPG', 'AM18DIS.JPG', 'AM19DIS.JPG', 'AM20DIS.JPG', 'AM21DIS.JPG', 'AM22DIS.JPG', 'AM23DIS.JPG', 'AM24DIS.JPG', 'AM25DIS.JPG', 'AM27DIS.JPG', 'AM28DIS.JPG', 'AM29DIS.JPG', 'AM30DIS.JPG', 'AM31DIS.JPG', 'AM32DIS.JPG', 'AM33DIS.JPG', 'AM34DIS.JPG', 'AM35DIS.JPG','BM03DIS.JPG', 'BM04DIS.JPG', 'BM05DIS.JPG', 'BM06DIS.JPG', 'BM07DIS.JPG', 'BM08DIS.JPG', 'BM09DIS.JPG', 'BM10DIS.JPG', 'BM11DIS.JPG', 'BM12DIS.JPG', 'BM13DIS.JPG', 'BM14DIS.JPG', 'BM15DIS.JPG', 'BM16DIS.JPG', 'BM17DIS.JPG', 'BM18DIS.JPG', 'BM19DIS.JPG', 'BM20DIS.JPG', 'BM21DIS.JPG', 'BM22DIS.JPG', 'BM23DIS.JPG', 'BM25DIS.JPG', 'BM26DIS.JPG', 'BM27DIS.JPG', 'BM28DIS.JPG', 'BM29DIS.JPG', 'BM30DIS.JPG', 'BM31DIS.JPG', 'BM32DIS.JPG', 'BM33DIS.JPG', 'BM34DIS.JPG', 'BM35DIS.JPG']
        var disgustFacesLengthMale = disgustFacesArrMale.length
        var disgustFacesLengthFemale = disgustFacesArrFemale.length

        var scrambledDisgustFacesArrFemale = ['scrambledAF01DIS.JPG', 'scrambledAF02DIS.JPG', 'scrambledAF03DIS.JPG', 'scrambledAF04DIS.JPG', 'scrambledAF05DIS.JPG', 'scrambledAF06DIS.JPG', 'scrambledAF07DIS.JPG', 'scrambledAF09DIS.JPG', 'scrambledAF10DIS.JPG', 'scrambledAF11DIS.JPG', 'scrambledAF12DIS.JPG', 'scrambledAF13DIS.JPG', 'scrambledAF14DIS.JPG', 'scrambledAF15DIS.JPG', 'scrambledAF16DIS.JPG', 'scrambledAF17DIS.JPG', 'scrambledAF19DIS.JPG', 'scrambledAF20DIS.JPG', 'scrambledAF21DIS.JPG', 'scrambledAF22DIS.JPG', 'scrambledAF23DIS.JPG', 'scrambledAF24DIS.JPG', 'scrambledAF25DIS.JPG', 'scrambledAF26DIS.JPG', 'scrambledAF27DIS.JPG', 'scrambledAF28DIS.JPG', 'scrambledAF29DIS.JPG', 'scrambledAF30DIS.JPG', 'scrambledAF31DIS.JPG', 'scrambledAF32DIS.JPG', 'scrambledAF33DIS.JPG', 'scrambledAF34DIS.JPG', 'scrambledAF35DIS.JPG','scrambledBF01DIS.JPG', 'scrambledBF02DIS.JPG', 'scrambledBF03DIS.JPG', 'scrambledBF04DIS.JPG', 'scrambledBF05DIS.JPG', 'scrambledBF06DIS.JPG', 'scrambledBF07DIS.JPG', 'scrambledBF09DIS.JPG', 'scrambledBF10DIS.JPG', 'scrambledBF11DIS.JPG', 'scrambledBF12DIS.JPG', 'scrambledBF13DIS.JPG', 'scrambledBF14DIS.JPG', 'scrambledBF15DIS.JPG', 'scrambledBF16DIS.JPG', 'scrambledBF17DIS.JPG', 'scrambledBF19DIS.JPG', 'scrambledBF20DIS.JPG', 'scrambledBF21DIS.JPG', 'scrambledBF22DIS.JPG', 'scrambledBF23DIS.JPG', 'scrambledBF24DIS.JPG', 'scrambledBF25DIS.JPG', 'scrambledBF26DIS.JPG', 'scrambledBF27DIS.JPG', 'scrambledBF28DIS.JPG', 'scrambledBF29DIS.JPG', 'scrambledBF30DIS.JPG', 'scrambledBF31DIS.JPG', 'scrambledBF32DIS.JPG', 'scrambledBF33DIS.JPG', 'scrambledBF34DIS.JPG', 'scrambledBF35DIS.JPG']
        var scrambledDisgustFacesArrMale = ['scrambledAM01DIS.JPG', 'scrambledAM02DIS.JPG', 'scrambledAM03DIS.JPG', 'scrambledAM04DIS.JPG', 'scrambledAM05DIS.JPG', 'scrambledAM06DIS.JPG', 'scrambledAM07DIS.JPG', 'scrambledAM08DIS.JPG', 'scrambledAM09DIS.JPG', 'scrambledAM10DIS.JPG', 'scrambledAM11DIS.JPG', 'scrambledAM12DIS.JPG', 'scrambledAM13DIS.JPG', 'scrambledAM14DIS.JPG', 'scrambledAM15DIS.JPG', 'scrambledAM16DIS.JPG', 'scrambledAM17DIS.JPG', 'scrambledAM18DIS.JPG', 'scrambledAM19DIS.JPG', 'scrambledAM20DIS.JPG', 'scrambledAM21DIS.JPG', 'scrambledAM22DIS.JPG', 'scrambledAM23DIS.JPG', 'scrambledAM24DIS.JPG', 'scrambledAM25DIS.JPG', 'scrambledAM27DIS.JPG', 'scrambledAM28DIS.JPG', 'scrambledAM29DIS.JPG', 'scrambledAM30DIS.JPG', 'scrambledAM31DIS.JPG', 'scrambledAM32DIS.JPG', 'scrambledAM33DIS.JPG', 'scrambledAM34DIS.JPG', 'scrambledAM35DIS.JPG','scrambledBM02DIS.JPG', 'scrambledBM03DIS.JPG', 'scrambledBM04DIS.JPG', 'scrambledBM05DIS.JPG', 'scrambledBM06DIS.JPG', 'scrambledBM07DIS.JPG', 'scrambledBM08DIS.JPG', 'scrambledBM09DIS.JPG', 'scrambledBM10DIS.JPG', 'scrambledBM11DIS.JPG', 'scrambledBM12DIS.JPG', 'scrambledBM13DIS.JPG', 'scrambledBM14DIS.JPG', 'scrambledBM15DIS.JPG', 'scrambledBM16DIS.JPG', 'scrambledBM17DIS.JPG', 'scrambledBM18DIS.JPG', 'scrambledBM19DIS.JPG', 'scrambledBM20DIS.JPG', 'scrambledBM21DIS.JPG', 'scrambledBM22DIS.JPG', 'scrambledBM23DIS.JPG', 'scrambledBM25DIS.JPG', 'scrambledBM26DIS.JPG', 'scrambledBM27DIS.JPG', 'scrambledBM28DIS.JPG', 'scrambledBM29DIS.JPG', 'scrambledBM30DIS.JPG', 'scrambledBM31DIS.JPG', 'scrambledBM32DIS.JPG', 'scrambledBM33DIS.JPG', 'scrambledBM34DIS.JPG', 'scrambledBM35DIS.JPG']

        for (let i=0; i <nTrialsRecall;i++){
        //Select cue Images (do this prior to cue-phase)

        var randomNeutralCueIdentifierFemale = getRandomInt(1,neutralFacesFemaleLength)
        var randomNeutralCueIdentifierMale = getRandomInt(1,neutralFacesMaleLength)
        var randomNeutralCueImageFemale = neutralFacesArrFemale[randomNeutralCueIdentifierFemale]
        var randomNeutralCueImageMale = neutralFacesArrMale[randomNeutralCueIdentifierMale]
        //Using same number identifier as cue, select neutral scrambled mask

        var randomScrambledNeutralMaskFemale = scrambledNeutralFacesArrFemale[randomNeutralCueIdentifierFemale]
        var randomScrambledNeutralMaskMale = scrambledNeutralFacesArrMale[randomNeutralCueIdentifierMale]

        var randomDisgustIdentifierMale = getRandomInt(1,disgustFacesLengthMale)
        var randomDisgustIdentifierFemale = getRandomInt(1,disgustFacesLengthFemale)
        var randomDisgustImageMale = disgustFacesArrMale[randomDisgustIdentifierMale]
        var randomDisgustImageFemale = disgustFacesArrFemale[randomDisgustIdentifierFemale]
        //Using same number identifier as cue, select disgust scrambled mask
        
        var randomScrambledDisgustMaskFemale = scrambledDisgustFacesArrFemale[randomDisgustIdentifierFemale]
        var randomScrambledDisgustMaskMale = scrambledDisgustFacesArrMale[randomDisgustIdentifierMale]

        //For backwards mask (always neutral face)...
        var randomNeutralMaskIdentifierFemale = getRandomInt(1,neutralFacesFemaleLength)
        //...ensure that the same face is not used were neutral cue face to be selected
        while (randomNeutralCueIdentifierFemale == randomNeutralMaskIdentifierFemale){ 
            var randomNeutralMaskIdentifierFemale = getRandomInt(1,neutralFacesFemaleLength)}
        //}
        var randomNeutralMaskImageFemale = neutralFacesArrFemale[randomNeutralMaskIdentifierFemale]

        var randomNeutralMaskIdentifierMale = getRandomInt(1,neutralFacesMaleLength)
        while (randomNeutralCueIdentifierMale==randomNeutralMaskIdentifierMale){
            var randomNeutralMaskIdentifierMale = getRandomInt(1,neutralFacesMaleLength)}
        var randomNeutralMaskImageMale = neutralFacesArrMale[randomNeutralMaskIdentifierMale]

        var NeutralImageCuePathMale = ['jspsych/neutralFaces',randomNeutralCueImageMale].join('/')
        var NeutralImageCuePathFemale = ['jspsych/neutralFaces',randomNeutralCueImageFemale].join('/')
        
        var scrambledNeutralImagePathMale = ['jspsych/scrambledNeutralFaces',randomScrambledNeutralMaskMale].join('/')
        var scrambledNeutralImagePathFemale = ['jspsych/scrambledNeutralFaces',randomScrambledNeutralMaskFemale].join('/')

        var DisgustImageCuePathMale = ['jspsych/disgustFaces',randomDisgustImageMale].join('/')
        var DisgustImageCuePathFemale = ['jspsych/disgustFaces',randomDisgustImageFemale].join('/')

        var scrambledDisgustImageCuePathMale = ['jspsych/scrambledDisgustFaces',randomScrambledDisgustMaskMale].join('/')
        var scrambledDisgustImagePathFemale = ['jspsych/scrambledDisgustFaces',randomScrambledDisgustMaskFemale].join('/')

        var randomNeutralMaskImagePathMale = ['jspsych/neutralFaces',randomNeutralMaskImageMale].join('/')
        var randomNeutralMaskImagePathFemale = ['jspsych/neutralFaces',randomNeutralMaskImageFemale].join('/')

        var CoinToss = jsPsych.randomization.sampleWithReplacement([0,1], 1)
        console.log= CoinToss
        if(CoinToss==0 && isEven(i)){
            //male neutral
                preloadedMaskImages[i]={
                scrambledMask: scrambledNeutralImagePathMale,
                cue: NeutralImageCuePathMale,
                neutralBackwardsMask: randomNeutralMaskImagePathMale,
                disgustMasks: 0,
                maleGender: 1
            }}else if(CoinToss==0 && isEven(i+1)){
                //female neutral
                preloadedMaskImages[i]={
                scrambledMask: scrambledNeutralImagePathFemale,
                cue: NeutralImageCuePathFemale,
                neutralBackwardsMask: randomNeutralMaskImagePathFemale,
                disgustMasks: 0,
                maleGender: 0}

            }else if(CoinToss==1 && isEven(i)){
                //male disgust
                preloadedMaskImages[i]={
                scrambledMask: scrambledDisgustImageCuePathMale,
                cue: DisgustImageCuePathMale,
                neutralBackwardsMask: randomNeutralMaskImagePathMale,
                disgustMasks: 1,
                maleGender: 1}
                }else if(CoinToss==1 && isEven(i+1)){
                //female disgust
                preloadedMaskImages[i]={
                scrambledMask: scrambledDisgustImagePathFemale,
                cue: DisgustImageCuePathFemale,
                neutralBackwardsMask: randomNeutralMaskImagePathFemale,
                disgustMasks: 1,
                maleGender: 0}
        }}
        var preloadedMaskImages = shuffle(preloadedMaskImages)

/////////////////////////////  BEGIN EXPERIMENT  ////////////////////////////////////////////
        //Message prompting user to begin presentation
        var timeline = [];
        
        if(isFirefox==0){
          var fireFoxCheck = {
        type: 'html-keyboard-response',
        stimulus: 'This program only works on Firefox. Please switch to Firefox. If you are using Firefox and are still seeing this message, please update to latest version or <b>contact chua.lab@brooklyn.cuny.edu</b> to troubleshoot',
        choices: jsPsych.NO_KEYS
          }
          timeline.push(fireFoxCheck)}
          
        var surveyTrial = {
        type: 'survey-text',
        questions: [
        {prompt: "Please Enter Your MTURK Worker ID", placeholder: "1234"}
        ]
        }
        timeline.push(surveyTrial)


        var DirectionsStepOne = {
            type: 'image-button-response',
            stimulus: 'directionsMemoryAssociation1.JPG',
            choices: ['View Directions for Step Two'],
            on_finish: function(data){
        data.iTrial = 1,
        data.Phase = 'IntroDirections1'
        data.ExperimentPhase ='break'
        }}
        timeline.push(DirectionsStepOne)

        var DirectionsStepTwo = {
            type: 'image-button-response',
            stimulus: 'directionsMemoryAssociation2.JPG',
            choices: ['Confirm that I am aged 18-65, and continue on to Practice Set'],
            on_finish: function(data){
        data.iTrial = 1,
        data.Phase = 'IntroDirections2'
        data.ExperimentPhase = 'break'
        }}
        timeline.push(DirectionsStepTwo)

////////////////////////////  PRACTICE PHASE  ///////////////////////////////////////////////
for(let i=0;i<nPracticeMemorizationTrials;i++){
    var face = faceNamePairsPractice[i].face;// change to LET instead of VAR after debugging
    var name = faceNamePairsPractice[i].name; //change to LET instead of VAR after debugging
    let practiceHeader = '<p><b> Practice Set </b></p>'
    let str1 = '<img src='
    let str2 = ' height="250px">'
    let str3 = ',</br>'
    let cfdDirectory = 'jspsych/CFDfaces/'
    let faceDir = cfdDirectory.concat(face)
    faceDir = "'"+faceDir+"'"
    var ImgStr = str1.concat(faceDir,str2,str3,'<b>',name,'</b>')
    var faceMemorization = {
    type: 'html-keyboard-response',
    // imgString = concat('<img src=',face,' height="250px"'),
    stimulus: [ImgStr],
    trial_duration: PresentationDuration,
    response_ends_trial: false,
    prompt: '<p> Do you feel as though the name fits the face? </p> Enter on keyboard, <b>F</b> for "fits", or <b>N</b> for "does not fit."',
    choices: ['f','n'],
    stimulus_width: 400,
    on_finish: function(data){
        data.iTrial = i+1,
        data.Phase = 'IntactFace';
        data.StimulusDurationSetting = PresentationDuration
        data.ExperimentPhase = 'Practice'
        }
    }
    timeline.push(faceMemorization)

    var fixation = {
        type: 'html-keyboard-response',
        stimulus: '<div style="font-size:60px;">+</div>',
        choices: jsPsych.NO_KEYS,
        trial_duration: 500,
        on_finish: function(data){
        data.iTrial = i+1,
        data.Phase = 'ITI';
        data.StimulusDurationSetting = ITIDuration
        data.ExperimentPhase = 'Practice'
        }
        }
        timeline.push(fixation)

//end of for-loop through all fit/doesn't fit trials
    jsPsych.init({
        timeline: timeline,
        //on_finish: function(){  jsPsych.data.displayData()}
    })}

i = []

var directionsBeforeTest = {
            type: 'image-button-response',
            stimulus: 'directionsForTest.JPG',
            choices: ['Continue'],
            on_finish: function(data){
        data.iTrial = 1,
        data.Phase = 'directionsForTest'
        data.ExperimentPhase ='break'
        }}
        timeline.push(directionsBeforeTest)

        var directionsBeforeTest2 = {
            type: 'image-button-response',
            stimulus: 'directionsForTest2.JPG',
            choices: ['Continue On to the Memory Test'],
            on_finish: function(data){
        data.iTrial = 1,
        data.Phase = 'directionsForTest2'
        data.ExperimentPhase ='break'
        }}
        timeline.push(directionsBeforeTest2)

////////////////////////////// PRACTICE RECALL PHASE//////////////////////////////////////////////////////////

        //Loop through a fleixble number of trials
        for (let i=0; i <nPracticeRecallTrials;i++){ 
                
        //1000msITI
        var ITI = {
        type: 'html-keyboard-response',
        stimulus: '<div style="font-size:60px;">+</div>',
        choices: jsPsych.NO_KEYS,
        trial_duration: ITIDuration,
        on_finish: function(data){
        data.StimulusDurationSetting = ITIDuration,
        data.iTrial = i+1,
        data.Phase = 'ITI';
        data.ExperimentPhase  = 'Practice'
        }
        }
        timeline.push(ITI)

        //Select cue Images (do this prior to cue-phase)
        var neutralFacesArr= ['AF01NES.JPG', 'AF02NES.JPG', 'AF03NES.JPG', 'AF04NES.JPG', 'AF05NES.JPG', 'AF06NES.JPG', 'AF07NES.JPG', 'AF08NES.JPG', 'AF09NES.JPG', 'AF10NES.JPG', 'AF11NES.JPG', 'AF12NES.JPG', 'AF13NES.JPG', 'AF14NES.JPG', 'AF15NES.JPG', 'AF16NES.JPG', 'AF17NES.JPG', 'AF18NES.JPG', 'AF19NES.JPG', 'AF20NES.JPG', 'AF21NES.JPG', 'AF22NES.JPG', 'AF23NES.JPG', 'AF24NES.JPG', 'AF25NES.JPG', 'AF26NES.JPG', 'AF27NES.JPG', 'AF28NES.JPG', 'AF29NES.JPG', 'AF30NES.JPG', 'AF31NES.JPG', 'AF32NES.JPG', 'AF33NES.JPG', 'AF34NES.JPG', 'AF35NES.JPG', 'AM01NES.JPG', 'AM02NES.JPG', 'AM03NES.JPG', 'AM04NES.JPG', 'AM05NES.JPG', 'AM06NES.JPG', 'AM07NES.JPG', 'AM08NES.JPG', 'AM09NES.JPG', 'AM10NES.JPG', 'AM11NES.JPG', 'AM13NES.JPG', 'AM14NES.JPG', 'AM15NES.JPG', 'AM17NES.JPG', 'AM18NES.JPG', 'AM21NES.JPG', 'AM22NES.JPG', 'AM23NES.JPG', 'AM25NES.JPG', 'AM26NES.JPG', 'AM27NES.JPG', 'AM28NES.JPG', 'AM29NES.JPG', 'AM30NES.JPG', 'AM31NES.JPG', 'AM32NES.JPG', 'AM33NES.JPG', 'AM34NES.JPG', 'AM35NES.JPG', 'BF01NES.JPG', 'BF02NES.JPG', 'BF03NES.JPG', 'BF04NES.JPG', 'BF05NES.JPG', 'BF06NES.JPG', 'BF07NES.JPG', 'BF08NES.JPG', 'BF09NES.JPG', 'BF10NES.JPG', 'BF11NES.JPG', 'BF12NES.JPG', 'BF13NES.JPG', 'BF14NES.JPG', 'BF15NES.JPG', 'BF16NES.JPG', 'BF17NES.JPG', 'BF18NES.JPG', 'BF19NES.JPG', 'BF20NES.JPG', 'BF21NES.JPG', 'BF22NES.JPG', 'BF23NES.JPG', 'BF24NES.JPG', 'BF25NES.JPG', 'BF26NES.JPG', 'BF27NES.JPG', 'BF28NES.JPG', 'BF29NES.JPG', 'BF30NES.JPG', 'BF31NES.JPG', 'BF32NES.JPG', 'BF33NES.JPG', 'BF34NES.JPG', 'BF35NES.JPG', 'BM01NES.JPG', 'BM02NES.JPG', 'BM03NES.JPG', 'BM04NES.JPG', 'BM05NES.JPG', 'BM06NES.JPG', 'BM07NES.JPG', 'BM08NES.JPG', 'BM09NES.JPG', 'BM10NES.JPG', 'BM11NES.JPG', 'BM12NES.JPG', 'BM13NES.JPG', 'BM14NES.JPG', 'BM16NES.JPG', 'BM21NES.JPG', 'BM22NES.JPG', 'BM23NES.JPG', 'BM24NES.JPG', 'BM25NES.JPG', 'BM26NES.JPG', 'BM27NES.JPG', 'BM28NES.JPG', 'BM30NES.JPG', 'BM31NES.JPG', 'BM32NES.JPG', 'BM33NES.JPG', 'BM34NES.JPG', 'BM35NES.JPG']
        var neutralFacesLength = neutralFacesArr.length
        var randomNeutralCueIdentifier = getRandomInt(1,neutralFacesLength)
        var randomNeutralCueImage = neutralFacesArr[randomNeutralCueIdentifier]
        //Using same number identifier as cue, select neutral scrambled mask
        var scrambledNeutralFacesArr = ['scrambledAF01NES.JPG', 'scrambledAF02NES.JPG', 'scrambledAF03NES.JPG', 'scrambledAF04NES.JPG', 'scrambledAF05NES.JPG', 'scrambledAF06NES.JPG', 'scrambledAF07NES.JPG', 'scrambledAF08NES.JPG', 'scrambledAF09NES.JPG', 'scrambledAF10NES.JPG', 'scrambledAF11NES.JPG', 'scrambledAF12NES.JPG', 'scrambledAF13NES.JPG', 'scrambledAF14NES.JPG', 'scrambledAF15NES.JPG', 'scrambledAF16NES.JPG', 'scrambledAF17NES.JPG', 'scrambledAF18NES.JPG', 'scrambledAF19NES.JPG', 'scrambledAF20NES.JPG', 'scrambledAF21NES.JPG', 'scrambledAF22NES.JPG', 'scrambledAF23NES.JPG', 'scrambledAF24NES.JPG', 'scrambledAF25NES.JPG', 'scrambledAF26NES.JPG', 'scrambledAF27NES.JPG', 'scrambledAF28NES.JPG', 'scrambledAF29NES.JPG', 'scrambledAF30NES.JPG', 'scrambledAF31NES.JPG', 'scrambledAF32NES.JPG', 'scrambledAF33NES.JPG', 'scrambledAF34NES.JPG', 'scrambledAF35NES.JPG', 'scrambledAM01NES.JPG', 'scrambledAM02NES.JPG', 'scrambledAM03NES.JPG', 'scrambledAM04NES.JPG', 'scrambledAM05NES.JPG', 'scrambledAM06NES.JPG', 'scrambledAM07NES.JPG', 'scrambledAM08NES.JPG', 'scrambledAM09NES.JPG', 'scrambledAM10NES.JPG', 'scrambledAM11NES.JPG', 'scrambledAM13NES.JPG', 'scrambledAM14NES.JPG', 'scrambledAM15NES.JPG', 'scrambledAM17NES.JPG', 'scrambledAM18NES.JPG', 'scrambledAM21NES.JPG', 'scrambledAM22NES.JPG', 'scrambledAM23NES.JPG', 'scrambledAM25NES.JPG', 'scrambledAM26NES.JPG', 'scrambledAM27NES.JPG', 'scrambledAM28NES.JPG', 'scrambledAM29NES.JPG', 'scrambledAM30NES.JPG', 'scrambledAM31NES.JPG', 'scrambledAM32NES.JPG', 'scrambledAM33NES.JPG', 'scrambledAM34NES.JPG', 'scrambledAM35NES.JPG', 'scrambledBF01NES.JPG', 'scrambledBF02NES.JPG', 'scrambledBF03NES.JPG', 'scrambledBF04NES.JPG', 'scrambledBF05NES.JPG', 'scrambledBF06NES.JPG', 'scrambledBF07NES.JPG', 'scrambledBF08NES.JPG', 'scrambledBF09NES.JPG', 'scrambledBF10NES.JPG', 'scrambledBF11NES.JPG', 'scrambledBF12NES.JPG', 'scrambledBF13NES.JPG', 'scrambledBF14NES.JPG', 'scrambledBF15NES.JPG', 'scrambledBF16NES.JPG', 'scrambledBF17NES.JPG', 'scrambledBF18NES.JPG', 'scrambledBF19NES.JPG', 'scrambledBF20NES.JPG', 'scrambledBF21NES.JPG', 'scrambledBF22NES.JPG', 'scrambledBF23NES.JPG', 'scrambledBF24NES.JPG', 'scrambledBF25NES.JPG', 'scrambledBF26NES.JPG', 'scrambledBF27NES.JPG', 'scrambledBF28NES.JPG', 'scrambledBF29NES.JPG', 'scrambledBF30NES.JPG', 'scrambledBF31NES.JPG', 'scrambledBF32NES.JPG', 'scrambledBF33NES.JPG', 'scrambledBF34NES.JPG', 'scrambledBF35NES.JPG', 'scrambledBM01NES.JPG', 'scrambledBM02NES.JPG', 'scrambledBM03NES.JPG', 'scrambledBM04NES.JPG', 'scrambledBM05NES.JPG', 'scrambledBM06NES.JPG', 'scrambledBM07NES.JPG', 'scrambledBM08NES.JPG', 'scrambledBM09NES.JPG', 'scrambledBM10NES.JPG', 'scrambledBM11NES.JPG', 'scrambledBM12NES.JPG', 'scrambledBM13NES.JPG', 'scrambledBM14NES.JPG', 'scrambledBM16NES.JPG', 'scrambledBM21NES.JPG', 'scrambledBM22NES.JPG', 'scrambledBM23NES.JPG', 'scrambledBM24NES.JPG', 'scrambledBM25NES.JPG', 'scrambledBM26NES.JPG', 'scrambledBM27NES.JPG', 'scrambledBM28NES.JPG', 'scrambledBM30NES.JPG', 'scrambledBM31NES.JPG', 'scrambledBM32NES.JPG', 'scrambledBM33NES.JPG', 'scrambledBM34NES.JPG', 'scrambledBM35NES.JPG']
        var randomScrambledNeutralMask = scrambledNeutralFacesArr[randomNeutralCueIdentifier]

        var disgustFacesArr = ['AF01DIS.JPG', 'AF02DIS.JPG', 'AF03DIS.JPG', 'AF04DIS.JPG', 'AF05DIS.JPG', 'AF06DIS.JPG', 'AF07DIS.JPG', 'AF09DIS.JPG', 'AF10DIS.JPG', 'AF11DIS.JPG', 'AF12DIS.JPG', 'AF13DIS.JPG', 'AF14DIS.JPG', 'AF15DIS.JPG', 'AF16DIS.JPG', 'AF17DIS.JPG', 'AF19DIS.JPG', 'AF20DIS.JPG', 'AF21DIS.JPG', 'AF22DIS.JPG', 'AF23DIS.JPG', 'AF24DIS.JPG', 'AF25DIS.JPG', 'AF26DIS.JPG', 'AF27DIS.JPG', 'AF28DIS.JPG', 'AF29DIS.JPG', 'AF30DIS.JPG', 'AF31DIS.JPG', 'AF32DIS.JPG', 'AF33DIS.JPG', 'AF34DIS.JPG', 'AF35DIS.JPG', 'AM01DIS.JPG', 'AM02DIS.JPG', 'AM03DIS.JPG', 'AM04DIS.JPG', 'AM05DIS.JPG', 'AM06DIS.JPG', 'AM07DIS.JPG', 'AM08DIS.JPG', 'AM09DIS.JPG', 'AM10DIS.JPG', 'AM11DIS.JPG', 'AM12DIS.JPG', 'AM13DIS.JPG', 'AM14DIS.JPG', 'AM15DIS.JPG', 'AM16DIS.JPG', 'AM17DIS.JPG', 'AM18DIS.JPG', 'AM19DIS.JPG', 'AM20DIS.JPG', 'AM21DIS.JPG', 'AM22DIS.JPG', 'AM23DIS.JPG', 'AM24DIS.JPG', 'AM25DIS.JPG', 'AM27DIS.JPG', 'AM28DIS.JPG', 'AM29DIS.JPG', 'AM30DIS.JPG', 'AM31DIS.JPG', 'AM32DIS.JPG', 'AM33DIS.JPG', 'AM34DIS.JPG', 'AM35DIS.JPG', 'BF01DIS.JPG', 'BF02DIS.JPG', 'BF03DIS.JPG', 'BF04DIS.JPG', 'BF05DIS.JPG', 'BF06DIS.JPG', 'BF07DIS.JPG', 'BF09DIS.JPG', 'BF10DIS.JPG', 'BF11DIS.JPG', 'BF12DIS.JPG', 'BF13DIS.JPG', 'BF14DIS.JPG', 'BF15DIS.JPG', 'BF16DIS.JPG', 'BF17DIS.JPG', 'BF19DIS.JPG', 'BF20DIS.JPG', 'BF21DIS.JPG', 'BF22DIS.JPG', 'BF23DIS.JPG', 'BF24DIS.JPG', 'BF25DIS.JPG', 'BF26DIS.JPG', 'BF27DIS.JPG', 'BF28DIS.JPG', 'BF29DIS.JPG', 'BF30DIS.JPG', 'BF31DIS.JPG', 'BF32DIS.JPG', 'BF33DIS.JPG', 'BF34DIS.JPG', 'BF35DIS.JPG', 'BM02DIS.JPG', 'BM03DIS.JPG', 'BM04DIS.JPG', 'BM05DIS.JPG', 'BM06DIS.JPG', 'BM07DIS.JPG', 'BM08DIS.JPG', 'BM09DIS.JPG', 'BM10DIS.JPG', 'BM11DIS.JPG', 'BM12DIS.JPG', 'BM13DIS.JPG', 'BM14DIS.JPG', 'BM15DIS.JPG', 'BM16DIS.JPG', 'BM17DIS.JPG', 'BM18DIS.JPG', 'BM19DIS.JPG', 'BM20DIS.JPG', 'BM21DIS.JPG', 'BM22DIS.JPG', 'BM23DIS.JPG', 'BM25DIS.JPG', 'BM26DIS.JPG', 'BM27DIS.JPG', 'BM28DIS.JPG', 'BM29DIS.JPG', 'BM30DIS.JPG', 'BM31DIS.JPG', 'BM32DIS.JPG', 'BM33DIS.JPG', 'BM34DIS.JPG', 'BM35DIS.JPG']
        var disgustFacesLength = disgustFacesArr.length
        var randomDisgustIdentifier = getRandomInt(1,disgustFacesLength)
        var randomDisgustImage = disgustFacesArr[randomDisgustIdentifier]
        //Using same number identifier as cue, select disgust scrambled mask
        var scrambledDisgustFacesArr = ['scrambledAF01DIS.JPG', 'scrambledAF02DIS.JPG', 'scrambledAF03DIS.JPG', 'scrambledAF04DIS.JPG', 'scrambledAF05DIS.JPG', 'scrambledAF06DIS.JPG', 'scrambledAF07DIS.JPG', 'scrambledAF09DIS.JPG', 'scrambledAF10DIS.JPG', 'scrambledAF11DIS.JPG', 'scrambledAF12DIS.JPG', 'scrambledAF13DIS.JPG', 'scrambledAF14DIS.JPG', 'scrambledAF15DIS.JPG', 'scrambledAF16DIS.JPG', 'scrambledAF17DIS.JPG', 'scrambledAF19DIS.JPG', 'scrambledAF20DIS.JPG', 'scrambledAF21DIS.JPG', 'scrambledAF22DIS.JPG', 'scrambledAF23DIS.JPG', 'scrambledAF24DIS.JPG', 'scrambledAF25DIS.JPG', 'scrambledAF26DIS.JPG', 'scrambledAF27DIS.JPG', 'scrambledAF28DIS.JPG', 'scrambledAF29DIS.JPG', 'scrambledAF30DIS.JPG', 'scrambledAF31DIS.JPG', 'scrambledAF32DIS.JPG', 'scrambledAF33DIS.JPG', 'scrambledAF34DIS.JPG', 'scrambledAF35DIS.JPG', 'scrambledAM01DIS.JPG', 'scrambledAM02DIS.JPG', 'scrambledAM03DIS.JPG', 'scrambledAM04DIS.JPG', 'scrambledAM05DIS.JPG', 'scrambledAM06DIS.JPG', 'scrambledAM07DIS.JPG', 'scrambledAM08DIS.JPG', 'scrambledAM09DIS.JPG', 'scrambledAM10DIS.JPG', 'scrambledAM11DIS.JPG', 'scrambledAM12DIS.JPG', 'scrambledAM13DIS.JPG', 'scrambledAM14DIS.JPG', 'scrambledAM15DIS.JPG', 'scrambledAM16DIS.JPG', 'scrambledAM17DIS.JPG', 'scrambledAM18DIS.JPG', 'scrambledAM19DIS.JPG', 'scrambledAM20DIS.JPG', 'scrambledAM21DIS.JPG', 'scrambledAM22DIS.JPG', 'scrambledAM23DIS.JPG', 'scrambledAM24DIS.JPG', 'scrambledAM25DIS.JPG', 'scrambledAM27DIS.JPG', 'scrambledAM28DIS.JPG', 'scrambledAM29DIS.JPG', 'scrambledAM30DIS.JPG', 'scrambledAM31DIS.JPG', 'scrambledAM32DIS.JPG', 'scrambledAM33DIS.JPG', 'scrambledAM34DIS.JPG', 'scrambledAM35DIS.JPG', 'scrambledBF01DIS.JPG', 'scrambledBF02DIS.JPG', 'scrambledBF03DIS.JPG', 'scrambledBF04DIS.JPG', 'scrambledBF05DIS.JPG', 'scrambledBF06DIS.JPG', 'scrambledBF07DIS.JPG', 'scrambledBF09DIS.JPG', 'scrambledBF10DIS.JPG', 'scrambledBF11DIS.JPG', 'scrambledBF12DIS.JPG', 'scrambledBF13DIS.JPG', 'scrambledBF14DIS.JPG', 'scrambledBF15DIS.JPG', 'scrambledBF16DIS.JPG', 'scrambledBF17DIS.JPG', 'scrambledBF19DIS.JPG', 'scrambledBF20DIS.JPG', 'scrambledBF21DIS.JPG', 'scrambledBF22DIS.JPG', 'scrambledBF23DIS.JPG', 'scrambledBF24DIS.JPG', 'scrambledBF25DIS.JPG', 'scrambledBF26DIS.JPG', 'scrambledBF27DIS.JPG', 'scrambledBF28DIS.JPG', 'scrambledBF29DIS.JPG', 'scrambledBF30DIS.JPG', 'scrambledBF31DIS.JPG', 'scrambledBF32DIS.JPG', 'scrambledBF33DIS.JPG', 'scrambledBF34DIS.JPG', 'scrambledBF35DIS.JPG', 'scrambledBM02DIS.JPG', 'scrambledBM03DIS.JPG', 'scrambledBM04DIS.JPG', 'scrambledBM05DIS.JPG', 'scrambledBM06DIS.JPG', 'scrambledBM07DIS.JPG', 'scrambledBM08DIS.JPG', 'scrambledBM09DIS.JPG', 'scrambledBM10DIS.JPG', 'scrambledBM11DIS.JPG', 'scrambledBM12DIS.JPG', 'scrambledBM13DIS.JPG', 'scrambledBM14DIS.JPG', 'scrambledBM15DIS.JPG', 'scrambledBM16DIS.JPG', 'scrambledBM17DIS.JPG', 'scrambledBM18DIS.JPG', 'scrambledBM19DIS.JPG', 'scrambledBM20DIS.JPG', 'scrambledBM21DIS.JPG', 'scrambledBM22DIS.JPG', 'scrambledBM23DIS.JPG', 'scrambledBM25DIS.JPG', 'scrambledBM26DIS.JPG', 'scrambledBM27DIS.JPG', 'scrambledBM28DIS.JPG', 'scrambledBM29DIS.JPG', 'scrambledBM30DIS.JPG', 'scrambledBM31DIS.JPG', 'scrambledBM32DIS.JPG', 'scrambledBM33DIS.JPG', 'scrambledBM34DIS.JPG', 'scrambledBM35DIS.JPG']
        var randomScrambledDisgustMask = scrambledDisgustFacesArr[randomDisgustIdentifier]

        //For backwards mask (always neutral face)...
        var randomNeutralMaskIdentifier = getRandomInt(1,neutralFacesLength)
        //...ensure that the same face is not used were neutral cue face to be selected
        while (randomNeutralCueIdentifier == randomNeutralMaskIdentifier){ 
            var randomNeutralMaskIdentifier = getRandomInt(1,neutralFacesLength)}
        //}
        var randomNeutralMaskImage = neutralFacesArr[randomNeutralMaskIdentifier]

        var NeutralImageCuePath = ['jspsych/neutralFaces',randomNeutralCueImage].join('/')
        var scrambledNeutralImagePath = ['jspsych/scrambledNeutralFaces',randomScrambledNeutralMask].join('/')
        var DisgustImageCuePath = ['jspsych/disgustFaces',randomDisgustImage].join('/')
        var scrambledDisgustImagePath = ['jspsych/scrambledDisgustFaces',randomScrambledDisgustMask].join('/')
        //chooseTheImage

        delete CoinToss
        if(i==0){var CoinToss = 0}
        if(i==1){var CoinToss = 1}
        if(i==2){
        var CoinToss = jsPsych.randomization.sampleWithReplacement([0,1], 1)}
        console.log= CoinToss
        if(CoinToss==0){
            var scrambledMaskPath= scrambledNeutralImagePath
            var imageCuePath= NeutralImageCuePath
        }else{
            var scrambledMaskPath= scrambledDisgustImagePath
            var imageCuePath= DisgustImageCuePath
        }

        //Finally, the path for the backwards Neutral Mask:
        var NeutralImageMaskPath = ['jspsych/neutralFaces',randomNeutralMaskImage].join('/')

        //250ms Forward-Mask (phase-scrambled face)
        var forwardMask = {
        type: 'image-keyboard-response',
        stimulus: preloadedMaskImages[i].scrambledMask,
        choices: jsPsych.NO_KEYS,
        stimulus_width: 300,
        trial_duration: forwardMaskDuration,
        on_finish: function(data){
        data.StimulusDurationSetting = forwardMaskDuration,
        data.iTrial = i+1,
        data.ExperimentPhase = 'Practice'
        data.Phase = 'forwardMask'
        if(data.stimulus.includes('NES.JPG')){
            data.correctResponse = neutralKey
            data= {test_part: 'test', correct_response: neutralKey}
            var correctResponse = neutralKey}
            else{
            data.correctResponse = disgustKey
            data= {test_part: 'test', correct_response: disgustKey}
            var correctResponse = disgustKey}
        }
        }
        timeline.push(forwardMask)
        var correctResponse= correctResponse
        //Define two variable stimuli for the cue, see integration below in "cue_proecure"

        // var sampledCueDuration= function(){
        // return jsPsych.randomization.sampleWithoutReplacement(cueDuration, 1)[0]}
 
        //present the cue (16ms)
        var cueImage = {
        type: 'image-keyboard-response',
        stimulus: preloadedMaskImages[i].cue,
        choices: jsPsych.NO_KEYS,
        stimulus_width: 300,
        trial_duration: cueDuration,
           on_finish: function(data){      
        data.StimulusDurationSetting = cueDuration,
        data.iTrial = i+1,
        data.ExperimentPhase = 'Practice'
        data.Phase = 'Cue';
        }}
        timeline.push(cueImage)


        //100ms Neutral Face 
        var maskImage = {
        type: 'image-keyboard-response',
        stimulus: preloadedMaskImages[i].neutralBackwardsMask,
        choices: jsPsych.NO_KEYS,
        stimulus_width: 300,
        trial_duration: backwardMaskDuration,
        on_finish: function(data){
            data.ExperimentPhase = 'Practice'
        data.StimulusDurationSetting = backwardMaskDuration,
        data.iTrial = i+1,
        data.Phase = 'backwardMask';
        data.ExperimentPhase = 'Practice'
        }
        }
        timeline.push(maskImage)

        //250ms Fixation Point 
        var fixation = {
        type: 'html-keyboard-response',
        stimulus: '<div style="font-size:60px;">+</div>',
        choices: jsPsych.NO_KEYS,
        trial_duration: fixationDuration,
        on_finish: function(data){
        data.StimulusDurationSetting = fixationDuration,
        data.iTrial = i+1,
        data.ExperimentPhase = 'Practice'
        data.Phase = 'fixationBtwnNeutralMaskAndPrompt';
        }
        }
        timeline.push(fixation)

        //Programming Recall Stimuli
        var faceRecall = hybridPracticeArray[i].face;// change to LET instead of VAR after debugging
        var nameRecall = hybridPracticeArray[i].name; //change to LET instead of VAR after debugging
        let rearranged = hybridPracticeArray[i].rearranged;
        let practiceHeader = '<p><b> Practice Set </b></p>'
        let str1 = '<img src='
        let str2 = 'height="250px">'
        let str3 = '</br>'
        var cfdDirectory = 'jspsych/CFDfaces/'
        var faceDirRecall = cfdDirectory.concat(faceRecall)
        faceDirRecall = "'"+faceDirRecall+"'"
        var ImgStrRecall = str1.concat(faceDirRecall,str2,str3,'<b>',nameRecall,'</b>')

    //     //Recall/Test 
    //     var recall = {
    //     type: 'html-keyboard-response',
    //     // imgString = concat('<img src=',face,' height="250px"'),
    //     stimulus: [ImgStrRecall],
    //     prompt: 'Enter on keyboard. <b>I</b> for intact, <b>R</b> for rearranged',
    //     choices: ['i','r'],
    //     stimulus_width: 400,
    //     on_finish: function(data){
    //     data.iTrial = i+1,
    //     data.ExperimentPhase = 'Practice'
    //     data.Rearranged = rearranged
    //     data.Phase = 'Recall'
    //     if(data.key_press == 82){
    //         data.didSubjectEnterRearranged= 1}
    //     else if(data.key_press == 73){
    //         data.didSubjectEnterRearranged= 0}
    // }}
    // timeline.push(recall)
    var intactRearrangedQueryPractice = {
        type: 'html-button-response',
        stimulus: [ImgStrRecall],
        prompt: '<p> Is this face-name pair intact or rearranged?',
        choices: ['Intact','Rearranged'],
        trial_duration: 5000,
        //stimulus_width: 400,
        on_finish: function(data){
            data.iTrial = i+1,
            data.ExperimentPhase = 'Practice',
            data.Phase = 'IntactOrRearranged',
            data.Face = hybridArray[i].face
            data.Name = hybridArray[i].name
            data.rearranged = rearranged
            if(data.button_pressed == 0){
                data.didSubjectEnterRearranged =0
            }else if(data.button_pressed ==1){
                data.didSubjectEnterRearranged = 1
            }
        }
    }
    timeline.push(intactRearrangedQueryPractice)
    var confidenceQueryPractice = {
        type: 'html-slider-response',
        // imgString = concat('<img src=',face,' height="250px"'),
        //lastResponse = jsPsych.data.get().last(1).values()[0].didSubjectEnterRearranged,
        stimulus: [ImgStrRecall],
        prompt: '<p>How confident are you in your decision?</p>',
        labels: ['0%','20%','40%','60%','80%','100%'],
        slider_start: 0,
        trial_duration: 5000,
        //stimulus_width: 400,

        //trial_duration: 100,
        //response_ends_trial: true,
        
        //require_movement: true,
        on_finish: function(data){
        data.iTrial = i+1,
        data.ExperimentPhase = 'Practice'
        data.Phase = 'ConfidenceQuery'
        data.rearranged = rearranged
        data.Face = hybridArray[i].face
        data.Name = hybridArray[i].name
        }
    }
    timeline.push(confidenceQueryPractice)

    var feedback = {
        type: 'html-button-response',
        stimulus: function(){
            // if using key press for categorical judgement:
            // var rearrangedEntry = jsPsych.data.get().last(2).values()[0].didSubjectEnterRearranged; 
            // var rearrangedStim = jsPsych.data.get().last(2).values()[0].Rearranged;
            var rearrangedEntry = jsPsych.data.get().last(2).values()[0].didSubjectEnterRearranged; 
            var rearrangedStim = jsPsych.data.get().last(2).values()[0].rearranged;

            //If Using slider for categorical judgment: 
        if(rearrangedEntry==undefined){
          return "Please remember to click either button REARRANGED or INTACT!"
        }
        
        if(rearrangedEntry==1 && rearrangedStim ==1){
        return "You are Correct. You Called A Rearranged Pair Rearranged";} 
        else if(rearrangedEntry==1 && rearrangedStim ==0){
        return "You are Incorrect. You Called an Intact Pair Rearranged";}
        else if(rearrangedEntry==0 && rearrangedStim == 0){
            return "You are Correct. You called an Intact Pair Intact";}
        else if(rearrangedEntry==0 && rearrangedStim ==1){
            return "You are Incorrect. You called a Rearranged Pair Intact";
        }
        else if(rearrangedEntry==2 && rearrangedStim ==0)
        {return "<p>You responded that you were not sure.</p> <p>The pair was intact.</p>"}
        else if(rearrangedEntry==2 && rearrangedStim ==1){
            return "<p>You responded that you were not sure.</p> <p>The pair was rearranged.</p>"
        }},
        choices: ['Continue'],
        on_finish: function(data){
        data.iTrial = i+1,
        data.ExperimentPhase = 'Practice',
        data.Phase = 'feedback';}}
        timeline.push(feedback)}
      
        var recapDirections = {
        type: 'image-button-response',
        stimulus: 'directionsMemoryAssociation3.JPG',
        choices: ['Continue On to Full Set'],
        on_finish: function(data){
        data.iTrial = i+1,
        data.Phase = 'DirectionsBeforeActualTEst',
        data.ExperimentPhase = 'Break';
        }}
        timeline.push(recapDirections) 

        var directionsBeforeTest22 = {
            type: 'image-button-response',
            stimulus: 'directionsForTest2.JPG',
            choices: ['Continue On to the Memory Test'],
            on_finish: function(data){
        data.iTrial = 1,
        data.Phase = 'directionsForTest2'
        data.ExperimentPhase ='break'
        }}
        timeline.push(directionsBeforeTest22)
    

////////////////////////////MEMORIZATION PHASE///////////////////////////////////////////
for(let i=0;i<nMemorizationTrials;i++){
    let face = faceNamePairs[i].face;// change to LET instead of VAR after debugging
    var name = faceNamePairs[i].name; //change to LET instead of VAR after debugging
    let str1 = '<img src='
    let str2 = ' height="250px">'
    let str3 = '</br>'
    let cfdDirectory = 'jspsych/CFDfaces/'
    let faceDir = cfdDirectory.concat(face)
    faceDir = "'"+faceDir+"'"
    var ImgStr = str1.concat(faceDir,str2,str3,'<b>',name,'</b>')
    var faceMemorization = {
    type: 'html-keyboard-response',
    // imgString = concat('<img src=',face,' height="250px"'),
    stimulus: [ImgStr],
    trial_duration: PresentationDuration,
    response_ends_trial: false,
    prompt: '<p> Do you feel as though the name fits the face? </p> Enter on keyboard, <b>F</b> for "fits", or <b>N</b> for "does not fit."',
    choices: ['f','n'],
    //stimulus_width: 400,
    on_finish: function(data){
        data.iTrial = i+1,
        data.Phase = 'IntactFace';
        data.StimulusDurationSetting = PresentationDuration
        data.rearranged = 0
        data.Face = faceNamePairs[i].face
        data.Name = faceNamePairs[i].name
        data.ExperimentPhase = 'Memorization'
        }
    }
    timeline.push(faceMemorization)

    var fixation = {
        type: 'html-keyboard-response',
        stimulus: '<div style="font-size:60px;">+</div>',
        choices: jsPsych.NO_KEYS,
        trial_duration: 500,
        on_finish: function(data){
        data.iTrial = i+1,
        data.Phase = 'ITI';
        data.StimulusDurationSetting = 500
        data.ExperimentPhase = 'Memorization'
        data.Phase = 'fixation'
        }
        }
        timeline.push(fixation)}


//////////////////////////////RECALL PHASE//////////////////////////////////////////////////////////
        var breakTrial = {
            type: 'html-keyboard-response',
            stimulus: 'Press Any Key to Begin Memory Test',
            on_finish: function(data){
        data.iTrial = 1,
        data.Phase = 'welcomeScreen'
        data.ExperimentPhase = 'Break'
        }}
        timeline.push(breakTrial)
        i = []

        for (let i=0; i <nTrialsRecall;i++){
        //1000msITI
        var ITI = {
        type: 'html-keyboard-response',
        stimulus: '<div style="font-size:60px;">+</div>',
        choices: jsPsych.NO_KEYS,
        trial_duration: ITIDuration,
        on_finish: function(data){
        data.StimulusDurationSetting = ITIDuration,
        data.iTrial = i+1,
        data.Phase = 'ITI';
        data.ExperimentPhase = 'Test'
        }
        }
        timeline.push(ITI)

        //250ms Forward-Mask (phase-scrambled face)
        var forwardMask = {
        type: 'image-keyboard-response',
        stimulus: preloadedMaskImages[i].scrambledMask,
        choices: jsPsych.NO_KEYS,
        stimulus_width: 300,
        trial_duration: forwardMaskDuration,
        on_finish: function(data){
        data.StimulusDurationSetting = forwardMaskDuration,
        data.iTrial = i+1,
        data.ExperimentPhase = 'Test'
        data.Phase = 'forwardMask'
        if(data.stimulus.includes('NES.JPG')){
            data.correctResponse = neutralKey
            data= {test_part: 'test', correct_response: neutralKey}
            var correctResponse = neutralKey}
            else{
            data.correctResponse = disgustKey
            data.ExperimentPhase = 'Test'
            data= {test_part: 'test', correct_response: disgustKey}
            var correctResponse = disgustKey}
        }
        }
        timeline.push(forwardMask)
        var correctResponse= correctResponse
        //Define two variable stimuli for the cue, see integration below in "cue_proecure"

        //var sampledCueDuration= function(){
        //return jsPsych.randomization.sampleWithoutReplacement(cueDuration, 1)[0]}
 
        //present the cue (16ms)
        var cueImage = {
        type: 'image-keyboard-response',
        stimulus: preloadedMaskImages[i].cue,
        choices: jsPsych.NO_KEYS,
        stimulus_width: 300,
        trial_duration: cueDuration,
           on_finish: function(data){      
        data.StimulusDurationSetting = cueDuration,
        data.iTrial = i+1,
        data.ExperimentPhase = 'Test'
        data.Phase = 'Cue';
        }}
        timeline.push(cueImage)


        //100ms Neutral Face 
        var maskImage = {
        type: 'image-keyboard-response',
        stimulus: preloadedMaskImages[i].neutralBackwardsMask,
        choices: jsPsych.NO_KEYS,
        stimulus_width: 300,
        trial_duration: backwardMaskDuration,
        on_finish: function(data){
            data.ExperimentPhase = 'Test'
        data.StimulusDurationSetting  = backwardMaskDuration,
        data.iTrial = i+1,
        data.Phase = 'backwardMask';
        }
        }
        timeline.push(maskImage)

        //250ms Fixation Point 
        var fixation = {
        type: 'html-keyboard-response',
        stimulus: '<div style="font-size:60px;">+</div>',
        choices: jsPsych.NO_KEYS,
        trial_duration: fixationDuration,
        on_finish: function(data){
        data.StimulusDurationSetting = fixationDuration,
        data.iTrial = i+1,
        data.ExperimentPhase = 'Test'
        data.Phase = 'fixationBtwnNeutralMaskAndPrompt';
        }
        }
        timeline.push(fixation)
        //Programming Recall Stimuli
        var faceRecall = hybridArray[i].face;// change to LET instead of VAR after debugging
        var nameRecall = hybridArray[i].name; //change to LET instead of VAR after debugging
        let str1 = '<img src='
        let str2 = ' height="250px">'
        let str3 = ',</br>'
        let cfdDirectory = 'jspsych/CFDfaces/'
        let faceDirRecall = cfdDirectory.concat(faceRecall)
        faceDirRecall = "'"+faceDirRecall+"'"
        var ImgStrRecall = str1.concat(faceDirRecall,str2,str3,'<b>',nameRecall,'</b>')
        let rearranged = hybridArray[i].rearranged;

    //     //Recall/Test 
    //     var recall = {
    //     type: 'html-keyboard-response',
    //     // imgString = concat('<img src=',face,' height="250px"'),
    //     stimulus: [ImgStrRecall],
    //     prompt: 'Enter on keyboard. <b>I</b> for intact, <b>R</b> for rearranged',
    //     choices: ['i','r'],
    //     stimulus_width: 400,
    //     on_finish: function(data){
    //     data.iTrial = i+1,
    //     data.ExperimentPhase = 'Test'
    //     data.Rearranged = rearranged
    //     data.Phase = 'Recall'
    //     }
    // }
    // timeline.push(recall)

    var intactRearrangedQuery = {
        type: 'html-button-response',
        stimulus: [ImgStrRecall],
        prompt: '<p> Is this face-name pair intact or rearranged?',
        choices: ['Intact','Rearranged'],
        trial_duration: 5000,
        //stimulus_width: 400,
        on_finish: function(data){
            data.iTrial = i+1,
            data.ExperimentPhase = 'Test',
            data.Phase = 'IntactOrRearranged',
            data.Face = hybridArray[i].face
            data.Name = hybridArray[i].name
            data.rearranged = rearranged
            if(data.button_pressed == 0){
                data.didSubjectEnterRearranged =0
            }else if(data.button_pressed ==1){
                data.didSubjectEnterRearranged = 1
            }
        }
    }
    timeline.push(intactRearrangedQuery)

    //var didSubjectEnterRearranged = jsPsych.data.get().last(1).values()[0].didSubjectEnterRearranged

    var confidenceQuery = {
        type: 'html-slider-response',
        // imgString = concat('<img src=',face,' height="250px"'),
        //lastResponse = jsPsych.data.get().last(1).values()[0].didSubjectEnterRearranged,
        stimulus: [ImgStrRecall],
        prompt: '<p>How confident are you in your decision?</p>',
        labels: ['0%','20%','40%','60%','80%','100%'],
        slider_start: 0,
        trial_duration: 5000,
        //stimulus_width: 400,

        //trial_duration: 100,
        //response_ends_trial: true,
        
        //require_movement: true,
        on_finish: function(data){
        data.iTrial = i+1,
        data.ExperimentPhase = 'Test'
        data.Phase = 'ConfidenceQuery'
        data.rearranged = rearranged
        data.Face = hybridArray[i].face
        data.Name = hybridArray[i].name
        }
    }
    timeline.push(confidenceQuery)
    }

        // //Ask Subject: Was "hidden face" emotional or neutral
        // var test = {
        // type: 'html-keyboard-response',
        // stimulus: '<p> What was the emotion of the hidden face? <br> Press, <b>d</b> for <i>disgust face</i> or <b>n</b> for <i>neutral face</i></p>',
        // choices: ['d', 'n'],
        // on_finish: function(data){
        // //data.Success = data.key_press == jsPsych.pluginAPI.convertKeyCharacterToKeyCode(correctResponse),
        // data.CharacterResponse = jsPsych.pluginAPI.convertKeyCodeToKeyCharacter(data.key_press),
        // data.iTrial = i+1,
        // data.Phase = 'Query';
        // }}
        // timeline.push(test)
        
        
        if(i == lastTrial){
        var lastTrialPhase = {
        type: 'html-button-response',
        stimulus: 'Thank you for completing the main memorization task. The remaining task will be brief and non-strenous.',
        choices: ['Continue On'],
        on_finish: function(data){
        data.iTrial = i+1,
        data.Phase = 'BreakBeforeDisgustDetectionTrials';
        data.ExperimentPhase = 'break'
        }
        }
        timeline.push(lastTrialPhase)}
        



        var directionsToDetectionTask = {
            type: 'image-button-response',
            stimulus: 'directionsOnlyDisgust.JPG',
            choices: ['Proceed to Final Task'],
            on_finish: function(data){
        data.iTrial = 1,
        data.Phase = 'directions'
        }}
        timeline.push(directionsToDetectionTask)
    

        ////////////DISGUSTFACEDETECTIONS///////////


        for (let i=0; i <postCalibrationTrials;i++){ 
        //1000msITI
        var ITI = {
        type: 'html-keyboard-response',
        stimulus: '<div style="font-size:60px;">+</div>',
        choices: jsPsych.NO_KEYS,
        trial_duration: ITIDuration,
        on_finish: function(data){
        data.StimulusDurationSetting = ITIDuration,
        data.iTrial = i+1,
        data.ExperimentPhase = 'Calibration',
        data.Phase = 'ITI';
        }
        }
        timeline.push(ITI)

        //250ms Forward-Mask (phase-scrambled face)
        var forwardMask = {
        type: 'image-keyboard-response',
        stimulus: preloadedMaskImages[i].scrambledMask,
        choices: jsPsych.NO_KEYS,
        stimulus_width: 300,
        trial_duration: forwardMaskDuration,
        on_finish: function(data){
        data.StimulusDurationSetting = forwardMaskDuration,
        data.iTrial = i+1,
        data.ExperimentPhase = 'Calibration',
        data.Phase = 'forwardMask'
        if(data.stimulus.includes('NES.JPG')){
            data.correctResponse = neutralKey
            data= {test_part: 'test', correct_response: neutralKey}
            var correctResponse = neutralKey}
            else{
            data.correctResponse = disgustKey
            data= {test_part: 'test', correct_response: disgustKey}
            var correctResponse = disgustKey}
        }
        }
        timeline.push(forwardMask)
        var correctResponse= correctResponse
        //Define two variable stimuli for the cue, see integration below in "cue_proecure"

        // var sampledCueDuration= function(){
        // return jsPsych.randomization.sampleWithoutReplacement(cueDuration, 1)[0]}
 
        //present the cue (16ms)
        var cueImage = {
        type: 'image-keyboard-response',
        stimulus: preloadedMaskImages[i].cue,
        choices: jsPsych.NO_KEYS,
        stimulus_width: 300,
        trial_duration: cueDuration,
           on_finish: function(data){      
        data.StimulusDurationSetting = cueDuration,
        data.iTrial = i+1,
        data.ExperimentPhase = 'Calibration',
        data.Phase = 'Cue';
        }}
        timeline.push(cueImage)


        //100ms Neutral Face 
        var maskImage = {
        type: 'image-keyboard-response',
        stimulus: preloadedMaskImages[i].neutralBackwardsMask,
        choices: jsPsych.NO_KEYS,
        stimulus_width: 300,
        trial_duration: backwardMaskDuration,
        on_finish: function(data){
        data.StimulusDurationSetting = backwardMaskDuration,
        data.iTrial = i+1,
        data.ExperimentPhase = 'Calibration',
        data.Phase = 'backwardMask';
        }
        }
        timeline.push(maskImage)

        //250ms Fixation Point 
        var fixation = {
        type: 'html-keyboard-response',
        stimulus: '<div style="font-size:60px;">+</div>',
        choices: jsPsych.NO_KEYS,
        trial_duration: fixationDuration,
        on_finish: function(data){
        data.StimulusDurationSetting = fixationDuration,
        data.iTrial = i+1,
        data.ExperimentPhase = 'Calibration',
        data.Phase = 'fixationBtwnNeutralMaskAndPrompt';
        }
        }
        timeline.push(fixation)

        //Ask Subject: Was "hidden face" emotional or neutral
        var test = {
        type: 'html-keyboard-response',
        stimulus: 'Did you see a disgust face? (Y/N)',
        choices: ['Y','N'],
        trial_duration: 5000,
        on_finish: function(data){
        //data.Success = data.key_press == jsPsych.pluginAPI.convertKeyCharacterToKeyCode(correctResponse),
        data.CharacterResponse = jsPsych.pluginAPI.convertKeyCodeToKeyCharacter(data.key_press),
        data.iTrial = i+1,
        data.ExperimentPhase = 'Calibration',
        data.Phase = 'Query';
        }}
        timeline.push(test)} 

        var Debriefing = {
            type: 'image-button-response',
            stimulus: 'debriefing.JPG',
            prompt: 'Your MTURK survey code is 230492',
            choices: ['After copying survey code, please press this button to complete. Thank You!'],
            on_finish: function(data){
        data.iTrial = 1,
        data.Phase = 'debriefing',
        data.ExperimentPhase = 'break';
        }}
        timeline.push(Debriefing)

        jsPsych.init({
            timeline: timeline,
            //preload_images: [neutralFacesArrFemale,neutralFacesArrMale,disgustFacesArrFemale,disgustFacesArrMale,scrambledDisgustFacesArrFemale,scrambledDisgustFacesArrMale],
            on_finish: function(){jsPsych.data.displayData()}
        })
    </script>
    
    </html>