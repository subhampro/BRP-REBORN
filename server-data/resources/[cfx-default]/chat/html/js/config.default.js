// DO NOT EDIT THIS FILE
// Copy it to `config.js` and edit it
window.CONFIG = {
  defaultTemplateId: 'default', //This is the default template for 2 args1
  defaultAltTemplateId: 'defaultAlt', //This one for 1 arg
  templates: { //You can add static templates here
    'default': '<div class="chat-message"><div class="chat-message-body"><strong>{0}:</strong> {1}</div></div>',
    'defaultAlt': '{0}',
    'print': '<pre>{0}</pre>',
    'example:important': '<h1>^2{0}</h1>',

    'ooc': '<div class="chat-message2 normal"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">OOC</span></div><span><b>{0} ({1}): </b><span class="label-msg-txt">{2}</span></span></div></div>',
    'cnormal': '<div class="chat-message2 normal"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type"></span></div><span><b>{0}: </b><span class="label-msg-txt">{1}</span></span></div></div>',
    'normal': '<div class="chat-message2 normal"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">Normal</span></div><b>{0}</b></div></div>',
    'report': '<div class="chat-message2 report"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">Report</span></div><span><b>{0} ({1}): </b><span class="label-msg-txt">{2}</span></span></div></div>',
    'creport': '<div class="chat-message2 report"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">{0}</span></div><span><b>{1}</b></span></div></div>',
    'success': '<div class="chat-message2 success"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">{0}</span></div><span><b>{1}</b></span></div></div>',
    'error': '<div class="chat-message2 error"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">{0}</span></div><span><b>{1}</b></span></div></div>',
    'warning': '<div class="chat-message2 warning"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">{0}</span></div><span><b>{1}</b></span></div></div>',
    'system': '<div class="chat-message2 system"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">SYSTEM</span></div><span><b>{0}</b></span></div></div>',
    'advert': '<div class="chat-message2 advert"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">Normal</span></div><b>{0}</b></div></div>',
    'emergency': '<div class="chat-message2 emergency"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">SYSTEM</span></div><span><b>{0}</b></span></div></div>',
    '911': '<div class="chat-message2 emergency"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">911</span></div><span><b>Emergency Call 911 #{0} | {1} </b><span class="label-msg-txt">{2}</span></span></div></div>',
    '311': '<div class="chat-message2 emergency"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">311</span></div><span><b>Emergency Call 311 #{0} | {1} </b><span class="label-msg-txt">{2}</span></span></div></div>',
    '911r': '<div class="chat-message2 emergency"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">911 Reply</span></div><span><b>Emergency Call 911r #{0} | {1} </b><span class="label-msg-txt">{2}</span></span></div></div>',
    '311r': '<div class="chat-message2 emergency"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">311 Reply</span></div><span><b>Emergency Call 311r #{0} | {1} </b><span class="label-msg-txt">{2}</span></span></div></div>',
    'ems-chat': '<div class="chat-message2 emergency"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">EMS Chat</span></div><span><b>{0} : </b><span class="label-msg-txt">{1}</span></span></div></div>',
    'police-chat': '<div class="chat-message2 emergency"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">Police Chat</span></div><span><b>{0} : </b><span class="label-msg-txt">{1}</span></span></div></div>',
    'showid': '<div class="chat-message2 advert"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">ID Card</span></div><span><strong>{0}:</strong><br><br> <strong>BSN:</strong> {1} <br><strong>First Name:</strong> {2} <br><strong>Last name:</strong> {3} <br><strong>Birthday:</strong> {4} <br><strong>Sex:</strong> {5} <br><strong>Height:</strong> {6}</span></div></div>',
    'showlawyer': '<div class="chat-message2 advert"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">ID Card</span></div><span><strong>{0}:</strong><br><br> <strong>BSN:</strong> {1} <br><strong>First Name:</strong> {2} <br><strong>Last name:</strong> {3} <br><strong>Birthday:</strong> {4} <br><strong>Sex:</strong> {5} <br><strong>Nationality:</strong> {6}</span></div></div>',
    'showdl': '<div class="chat-message2 advert"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">ID Card</span></div><span><strong>{0}:</strong><br><br> <strong>First Name:</strong> {1} <br><strong>Last name:</strong> {2} <br><strong>Birthday:</strong> {3} <br><strong>Driving licenses:</strong> {4}</span></div></div>',
    'showlawyerl': '<div class="chat-message2 advert"><div class="label-msg"><div class="label-msg-details"><span class="label-msg-type">ID Card</span></div><span><strong>{0}:</strong><br><br> <strong>No-ID:</strong> {1} <br><strong>First Name:</strong> {2} <br><strong>Last name:</strong> {3} <br><strong>BSN:</strong> {4} <br><strong>Job:</strong> {5}</span></div></div>',
  },
  fadeTimeout: 4000,
  suggestionLimit: 5,
  style: {
    background: 'transparent',
    width: '28vw',
    height: '22vh',
  }
};

/*
  style: {
    background: 'rgba(255, 93, 0, 0.62)',
    border: '1px solid #000000',
    width: '38%',
    height: '22%',
  }
*/