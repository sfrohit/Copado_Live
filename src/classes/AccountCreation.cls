Public class AccountCreation {
Public Account createAccount(String name, Account a){
//comment 1 changes the comment
a.Description = 'Default Account Description';
// changes to the comment
if(a.Description!=null)return a;
else a.Description = 'Default Description';

return null;

}

}
