/**
 * fn_checkPulseLocal.sqf
 * @Descr: N/A
 * @Author: Glowbal
 *
 * @Arguments: []
 * @Return:
 * @PublicAPI: false
 */

#include "script_component.hpp"

private ["_caller","_unit", "_heartRateOutput", "_heartRate","_logOutPut", "_title","_content"];
_caller = _this select 0;
_unit = _this select 1;


_heartRate = [_unit,QGVAR(heartRate)] call EFUNC(common,getDefinedVariable);
if (!alive _unit) then {
    _heartRate = 0;
};
_heartRateOutput = "STR_ACE_CHECK_PULSE_OUTPUT_5";
_logOutPut = "No heart rate";

if (_heartRate > 1.0) then {
    if ([_caller] call FUNC(isMedic)) then {
        _heartRateOutput = "STR_ACE_CHECK_PULSE_OUTPUT_1";
        _logOutPut = format["%1",round(_heartRate)];
    } else {
        // non medical personel will only find a pulse/HR
        _heartRateOutput = "STR_ACE_CHECK_PULSE_OUTPUT_2";
        _logOutPut = "Weak";
        if (_heartRate > 60) then {
            if (_heartRate > 100) then {
                _heartRateOutput = "STR_ACE_CHECK_PULSE_OUTPUT_3";
                _logOutPut = "Strong";
            } else {
                _heartRateOutput = "STR_ACE_CHECK_PULSE_OUTPUT_4";
                _logOutPut = "Normal";
            };
        };
    };
};

_title = "STR_ACE_CHECK_PULSE";
_content = ["STR_ACE_CHECK_PULSE_CHECKED_MEDIC",_heartRateOutput];
[_caller, _title, _content, 0, [[_unit] call EFUNC(common,getName), round(_heartRate)]] call EFUNC(gui,sendDisplayInformationTo);

if (_logOutPut != "") then {
    [_unit,"examine",format["%1 checked Heart Rate: %2",[_caller] call EFUNC(common,getName),_logOutPut]] call FUNC(addToQuickViewLog);
};
