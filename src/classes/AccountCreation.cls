Public class AccountCreation {
Public Account createAccount(String name, Account a){
//comment 1
a.Description = 'Default Account Description';
// if statement
if(a.Description!=null)return a;
else a.Description = 'Default Description';

return null;

}

}