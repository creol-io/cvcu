var CarbonVCU = artifacts.require("./CarbonVCU.sol");

module.exports = function(deployer,accounts) {
    
    deployer.deploy(CarbonVCU,"tester","test1","0x44515119087cb5a19ddca3e909ff6537c23f9ca8");
	
	
	
};