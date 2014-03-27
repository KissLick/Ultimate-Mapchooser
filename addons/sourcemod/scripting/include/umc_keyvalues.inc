#if defined _umc_keyvalues_included
    #endinput
#endif
#define _umc_keyvalues_included

#pragma semicolon 1

#include <sourcemod>
#include <umc-core>

/**
 * Get map key value
 *
 * @param map		Map name, if empty -> current map is used
 * @param key		Key name
 * @param value		Buffer to store key value
 * @param size		Max size of buffer
 * @param defvalue	Default key value
 *
 * @noreturn
 */
native UMC_GetMapKeyValue( const String:map[] = "", const String:key[], String:value[], size, const String:defvalue[] = "" );

/**
 * Get map group key value
 *
 * @param group		Map group name, if empty -> map group of current map is used
 * @param key		Key name
 * @param value		Buffer to store key value
 * @param size		Max size of buffer
 * @param defvalue	Default key value
 *
 * @noreturn
 */
native UMC_GetMapGroupKeyValue( const String:group[] = "", const String:key[], String:value[], size, const String:defvalue[] = "" );
