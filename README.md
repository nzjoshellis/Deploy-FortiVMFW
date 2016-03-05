# Deploy-FortiVMFW
Clones the Fortigate VM Files and then deploys them to a Hyper-V VM.

# Prerequsites 
The variables need to be edited to suit your lab envionrment (Hyper-V File locations, Switch Names and Fortigate File locations).
The Fortigate VM files can be downloaded from the Fortigate Support Portal.

# Forti-VM Configuration
Once the Fortigate Firewall has been deployed, you will need to assign an IP from the console.

Login: admin  
Password: (blank)  
Fortigate-VM64-HV# config system interface  
Fortigate-VM64-HV (interface)# edit port1  
Fortigate-VM64-HV (port1)# set ip 10.1.1.254/24  
Fortigate-VM64-HV (port1)# set allowaccess ping http https  
Fortigate-VM64-HV (port1)# set alias "LAN"  
Fortigate-VM64-HV (port1)# end  
Fortigate-VM64-HV# config system interface  
Fortigate-VM64-HV (interface)# edit port2   
Fortigate-VM64-HV (port2)# set mode dhcp  
Fortigate-VM64-HV (port2)# set alias "WAN"  
Fortigate-VM64-HV (port2)# end  
