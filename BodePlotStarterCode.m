% RC Filter Transfer Function — Starter Code
% =====================================================================
% Instructions:
%   1. Rename this file to "rcFilterResponse.m"
%      (MATLAB requires the filename to match the function name.)
%   2. Complete the line marked "=>".
%   3. Submit rcFilterResponse.m via the MATLAB Grader link in Canvas.
%   4. Once MATLAB Grader confirms your function, use the plotting
%      script in the lab manual to generate figures 1–4.
% =====================================================================

function [H_lp, H_hp] = rcFilterResponse(R, C, f)
% RCFILTERRESPONSE  Returns complex transfer function values for RC
%                   low-pass and high-pass filters.
%
%   Inputs:  R   - resistance (ohms)
%            C   - capacitance (farads)
%            f   - frequency vector (Hz)
%   Outputs: H_lp - complex low-pass transfer function values
%            H_hp - complex high-pass transfer function values

w    = 2*pi*f;                          % angular frequency (rad/s)
H_lp = 1 ./ (1 + 1j*w*R*C);           % low-pass transfer function
% =>  H_hp = ......                     % COMPLETE: high-pass transfer function

end
