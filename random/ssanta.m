clear; close all; clc
rng(999) % seed for randomization - I used a different seed from this so no peeking!
mail = 'secretsanta.wiecon@gmail.com'; % Email login
password = 'DeanCorbae';  
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','E_mail',mail); % Other stuff necessary to get gmail working
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

names = {'Michael' 'Danny' 'Emily' 'Alex' 'Sarah' 'Leah' 'Laura'};
% emails = {'nattinger@wisc.edu' 'nattinger@wisc.edu' 'nattinger@wisc.edu' 'nattinger@wisc.edu' 'nattinger@wisc.edu' 'nattinger@wisc.edu' 'nattinger@wisc.edu'}; %testing
emails = {'nattinger@wisc.edu' 'edgeldan@gmail.com' 'ecase2@wisc.edu' 'vonhafften@wisc.edu' 'sbass3@wisc.edu' 'goldleaha@gmail.com' 'lauramarieschroeder@gmail.com'};
exclude = [2 6; 6 2; 4 7; 7 4]; %SO's can't get each other
n=length(names);
ddone = 0; %is draw done?
while ddone ==0
    draw = randperm(n); %random permutation - will check if valid later
    ddone = 1;
    for i=1:n;  if draw(i)==i ; ddone = 0; end; end %check if valid draw 
    for i=1:size(exclude,1); if draw(exclude(i,1))==exclude(i,2); ddone=0; end; end %check if SO's got each other
end
for i=1:n %send email
    sendmail(emails{i},'Secret Santa',['Hi ' names{i} ',  You are assigned ' names{draw(i)} ' for secret santa! -Matlab <3'])
end
clear