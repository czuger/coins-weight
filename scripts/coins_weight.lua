-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- Skill properties

-- Initialization
function onInit()
	if User.isHost() then
		Comm.registerSlashHandler("ccweight", computeCoinsWeight);
	end
end
			
function computeCoinsWeight(command, parameters)
	if User.isHost() then
		for _,v in pairs(DB.getChildren("partysheet.partyinformation")) do
			local sClass, sRecord = DB.getValue(v, "link");
			Debug.chat( sRecord );
			if sClass == "charsheet" and sRecord then
				local nodePC = DB.findNode(sRecord);
				if nodePC then
					computePCCoinsWeigh( nodePC );
				end
			end
		end
	end
end

function onCoinsValueChanged( nodeWin )
	local rActor = ActorManager.getActor("pc", nodeWin ); 
	local nodePC = DB.findNode(rActor['sCreatureNode']);
	CoinsWeight.computePCCoinsWeigh( nodePC );
end

function computePCCoinsWeigh( nodePC )
	local weight = 0;
	for _,coin in pairs(DB.getChildren(nodePC, "coins")) do
		weight = weight + DB.getValue(coin, "amount", "")	;					
	end
	
	-- We have now computed the coins weight for this PC
	weight = math.floor( weight / 50 );
	DB.setValue( nodePC.getPath() .. '.encumbrance.treasure', 'number', weight );
end
