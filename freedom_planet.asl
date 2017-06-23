state("FP", "1.21.4")
{
	double igt : "FP.exe", 0x1DD5100, 0x14, 0x1B8;
	uint totalIgt : "FP.exe", 0x1DD4EA0, 0x64, 0x3C;
	int frame : "FP.exe", 0x1DD4D50;
}

state("FP", "1.20.4")
{
	double igt : "FP.exe", 0x1DAE6C8, 0x14, 0x1B8;
	uint totalIgt : "FP.exe", 0x1DAE488, 0x64, 0x3C;
	int frame : "FP.exe", 0x1DAE338;
}

state("FP","1.21.5")
{
	double igt : "FP.exe", 0x167F458, 0x3C8, 0x14, 0x1B8;
	uint totalIgt : "FP.exe", 0x0166AD18, 0x64, 0x3C;
	int frame : "FP.exe", 0x166ABC8;
}
startup
{
	timer.OnStart += (s, e) =>
	{
		vars.time = 0;
		vars.lastSplit = 0;		
		vars.doSplit = false;
	};
}

init
{
	switch (modules.First().ModuleMemorySize)
	{
		case 0x01F13000:
			version = "1.21.4";
			break;
		case 0x01EDD000:
			version = "1.20.4";
			break;
		case 0x017AB000:
			version = "1.21.5";
			break;
		default:
			print("Could not detect version.");
			break;
	}
}

start
{
	return (current.frame == 20 || current.frame == 16 || current.frame == 81) && old.frame == 6;
}

split
{
	return current.frame > 15 && old.frame == 8;
}

reset
{
	return current.frame <= 3;
}

isLoading
{
	return true;
}

gameTime
{
	if (current.totalIgt > vars.lastSplit)
	{
			vars.lastSplit = (double)current.totalIgt;
			return TimeSpan.FromMilliseconds(vars.lastSplit);
	}

	double newTime = vars.lastSplit + current.igt;
	
	if (newTime > vars.time)
		vars.time = newTime;
	
	return TimeSpan.FromMilliseconds(vars.time);
}
