/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *                               Ultimate Mapchooser - Key Values                                *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
 
#pragma semicolon 1

#include <sourcemod>
#include <umc-core>
#include <umc_utils>

#undef REQUIRE_PLUGIN

//Auto update
// #include <updater>
// #if AUTOUPDATE_DEV
    // #define UPDATE_URL "http://www.ccs.neu.edu/home/steell/sourcemod/ultimate-mapchooser/dev/updateinfo-umc-mapcommands.txt"
// #else
    // #define UPDATE_URL "http://www.ccs.neu.edu/home/steell/sourcemod/ultimate-mapchooser/updateinfo-umc-mapcommands.txt"
// #endif

public Plugin:myinfo =
{
    name = "[UMC] KeyValues",
    author = "Raska",
    description = "",
    version = PL_VERSION,
    url = "http://forums.alliedmods.net/showthread.php?t=134190"
}

// #if AUTOUPDATE_ENABLE

// public OnPluginStart()
// {
    // if (LibraryExists("updater"))
    // {
        // Updater_AddPlugin(UPDATE_URL);
    // }
// }

public APLRes:AskPluginLoad2( Handle:myself, bool:late, String:error[], err_max )
{
	CreateNative( "UMC_GetMapKeyValue", Native_GetMapKeyValue );
	CreateNative( "UMC_GetMapGroupKeyValue", Native_GetMapGroupKeyValue );
	
	RegPluginLibrary("UMC-KeyValues");

	return APLRes_Success;
}

// Called when a new API library is loaded. Used to register UMC auto-updating.
// public OnLibraryAdded(const String:name[])
// {
    // if (StrEqual(name, "updater"))
    // {
        // Updater_AddPlugin(UPDATE_URL);
    // }
// }
// #endif

public Native_GetMapKeyValue( Handle:plugin, numParams )
{
	new size = GetNativeCell( 4 );

	decl String:key[ 128 ], String:value[ 128 ], String:defvalue[ 128 ], String:map[ 128 ];
	GetNativeString( 2, key, sizeof( key ) );
	GetNativeString( 3, value, sizeof( value ) );
	GetNativeString( 5, defvalue, sizeof( defvalue ) );
	
	if( GetNativeString( 1, map, sizeof( map ) ) == SP_ERROR_NONE || strlen( map ) == 0 )
		GetCurrentMap( map, sizeof( map ) );
	
	GetMapKeyValue( key, value, size, defvalue, map );
	
	SetNativeString( 3, value, 128 );
	
	return 0;
}

public Native_GetMapGroupKeyValue( Handle:plugin, numParams )
{
	new size = GetNativeCell( 4 );

	decl String:key[ 128 ], String:value[ 128 ], String:defvalue[ 128 ], String:group[ 128 ];
	GetNativeString( 2, key, sizeof( key ) );
	GetNativeString( 3, value, sizeof( value ) );
	GetNativeString( 5, defvalue, sizeof( defvalue ) );
	
	if( GetNativeString( 1, group, sizeof( group ) ) == SP_ERROR_NONE || strlen( group ) == 0 )
		UMC_GetCurrentMapGroup( group, sizeof( group ) );
	
	GetMapGroupKeyValue( key, value, size, defvalue, group );
	
	SetNativeString( 3, value, 128 );
	
	return 0;
}

GetMapKeyValue( const String:valuekey[], String:value[], size, const String:defvalue[], const String:map[] )
{
	new Handle:kv = GetKvFromFile( "umc_mapcycle.txt", "umc_mapcycle" );
	
	decl String:group[ 128 ];
	
	if( !KvFindGroupOfMap( kv, map, group, sizeof( group ) ) )
	{
		strcopy( value, size, defvalue );
		return;
	}
	
	KvJumpToKey( kv, group );
	
	if( KvJumpToKey( kv, map ) )
	{    
		KvGetString( kv, valuekey, value, size, defvalue );
	}
	else
	{
		strcopy( value, size, defvalue );
	}
	
	CloseHandle( kv );
}

GetMapGroupKeyValue( const String:valuekey[], String:value[], size, const String:defvalue[], const String:group[] )
{
	new Handle:kv = GetKvFromFile( "umc_mapcycle.txt", "umc_mapcycle" );
	
	if( KvJumpToKey( kv, group ) )
	{    
		KvGetString( kv, valuekey, value, size, defvalue );
	}
	else
	{
		strcopy( value, size, defvalue );
	}
	
	CloseHandle( kv );
}
