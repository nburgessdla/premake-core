--
-- tests/actions/vstudio/cs2005/test_platform_groups.lua
-- Check creation of per-platform property groups in VS2005+ C# projects.
-- Copyright (c) 2009-2013 Jason Perkins and the Premake project
--

	local suite = test.declare("vstudio_cs2005_platform_groups")
	local cs2005 = premake.vstudio.cs2005

--
-- Setup
--

	function suite.setup()
		_ACTION = "vs2008"
	end

	local function prepare(platform)
		local sln = solution ("MySolution")
		configurations ("Debug")
		platforms (platform)
		local prj = project ("MyProject")
		language "C#"
		local cfg = test.getconfig(prj, "Debug", platform)
		cs2005.propertyGroup(cfg)
	end


--
-- Check defaults.
--

	function suite.vs2008()
		_ACTION = "vs2008"
		prepare()
		test.capture [[
	<PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
		]]
	end


	function suite.vs2010()
		_ACTION = "vs2010"
		prepare()
		test.capture [[
	<PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
		<PlatformTarget>AnyCPU</PlatformTarget>
		]]
	end


--
-- Check handling of specific architectures.
--

	function suite.vs2008_onAnyCpu()
		_ACTION = "vs2008"
		prepare("Any CPU")
		test.capture [[
	<PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
		]]
	end


	function suite.vs2010_onAnyCpu()
		_ACTION = "vs2010"
		prepare("Any CPU")
		test.capture [[
	<PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
		<PlatformTarget>AnyCPU</PlatformTarget>
		]]
	end

	function suite.onX86()
		prepare("x86")
		test.capture [[
	<PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|x86' ">
		<PlatformTarget>x86</PlatformTarget>
		]]
	end


	function suite.onX86_64()
		prepare("x86_64")
		test.capture [[
	<PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|x64' ">
		<PlatformTarget>x64</PlatformTarget>
		]]
	end
