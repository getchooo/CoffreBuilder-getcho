---StringToArray
---
--- Reference : Frazzle <3
---
---@param str string
function StringToArray(str)
    local charCount = #str
    local strCount = math.ceil(charCount / 99)
    local strings = {}

    for i = 1, strCount do
        local start = (i - 1) * 99 + 1
        local clamp = math.clamp(#string.sub(str, start), 0, 99)
        local finish = ((i ~= 1) and (start - 1) or 0) + clamp

        strings[i] = string.sub(str, start, finish)
    end

    return strings
end

---@param str string
---@param font number
---@param scale number
---@return _G
---@public
function MeasureStringWidth(str, font, scale)
    BeginTextCommandWidth("CELL_EMAIL_BCON")
    AddTextComponentSubstringPlayerName(str)
    SetTextFont(font or 0)
    SetTextScale(1.0, scale or 0)
    return EndTextCommandGetWidth(true) * 1920
end


---@param str string
function AddText(str)
    local str = tostring(str)
    local charCount = #str

    if charCount < 100 then
        AddTextComponentSubstringPlayerName(str)
    else
        local strings = StringToArray(str)

        for s = 1, #strings do
            AddTextComponentSubstringPlayerName(strings[s])
        end
    end
end


---@param Text string
---@param X number
---@param Y number
---@param Font number
---@param Scale number
---@param R number
---@param G number
---@param B number
---@param A number
---@param Alignment string
---@param DropShadow boolean
---@param Outline boolean
---@param WordWrap number
---@return function
---@public
function GetLineCount(Text, X, Y, Font, Scale, R, G, B, A, Alignment, DropShadow, Outline, WordWrap)
    ---@type table
    local Text, X, Y = tostring(Text), (tonumber(X) or 0) / 1920, (tonumber(Y) or 0) / 1080
    SetTextFont(Font or 0)
    SetTextScale(1.0, Scale or 0)
    SetTextColour(tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)
    if DropShadow then
        SetTextDropShadow()
    end
    if Outline then
        SetTextOutline()
    end
    if Alignment ~= nil then
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            SetTextCentre(true)
        elseif Alignment == 2 or Alignment == "Right" then
            SetTextRightJustify(true)
        end
    end
    if tonumber(WordWrap) and tonumber(WordWrap) ~= 0 then
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            SetTextWrap(X - ((WordWrap / 1920) / 2), X + ((WordWrap / 1920) / 2))
        elseif Alignment == 2 or Alignment == "Right" then
            SetTextWrap(0, X)
        else
            SetTextWrap(X, X + (WordWrap / 1920))
        end
    else
        if Alignment == 2 or Alignment == "Right" then
            SetTextWrap(0, X)
        end
    end

    BeginTextCommandLineCount("CELL_EMAIL_BCON")
    AddText(Text)
    return GetTextScreenLineCount(X, Y)
end

---RenderText
---
--- Reference : https://github.com/iTexZoz/NativeUILua_Reloaded/blob/master/UIElements/UIResText.lua#L189
---
---@param Text string
---@param X number
---@param Y number
---@param Font number
---@param Scale number
---@param R number
---@param G number
---@param B number
---@param A number
---@param Alignment string
---@param DropShadow boolean
---@param Outline boolean
---@param WordWrap number
---@return nil
---@public
function RenderText(Text, X, Y, Font, Scale, R, G, B, A, Alignment, DropShadow, Outline, WordWrap)
    ---@type table
    local Text, X, Y = tostring(Text), (tonumber(X) or 0) / 1920, (tonumber(Y) or 0) / 1080
    SetTextFont(Font or 0)
    SetTextScale(1.0, Scale or 0)
    SetTextColour(tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)
    if DropShadow then
        SetTextDropShadow()
    end
    if Outline then
        SetTextOutline()
    end
    if Alignment ~= nil then
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            SetTextCentre(true)
        elseif Alignment == 2 or Alignment == "Right" then
            SetTextRightJustify(true)
        end
    end
    if tonumber(WordWrap) and tonumber(WordWrap) ~= 0 then
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            SetTextWrap(X - ((WordWrap / 1920) / 2), X + ((WordWrap / 1920) / 2))
        elseif Alignment == 2 or Alignment == "Right" then
            SetTextWrap(0, X)
        else
            SetTextWrap(X, X + (WordWrap / 1920))
        end
    else
        if Alignment == 2 or Alignment == "Right" then
            SetTextWrap(0, X)
        end
    end
    BeginTextCommandDisplayText("CELL_EMAIL_BCON")
    AddText(Text)
    EndTextCommandDisplayText(X, Y)
end


local SettingsButton = {
    Rectangle = { Y = 0, Width = 420, Height = 38 },
    Line = { X = 8, Y = 15 },
    SelectedSprite = { Dictionary = "commonmenu", Texture = "gradient_nav", Y = 0, Width = 431, Height = 38 },
}


function RageUI.Line(Style)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            local Option = RageUI.Options + 1
            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
                if Style then
                    if Style.BackgroundColor then
                        RenderRectangle(CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height, Style.BackgroundColor[1], Style.BackgroundColor[2], Style.BackgroundColor[3], Style.BackgroundColor[4])
                    end
                    if Style.Line then
                        RenderRectangle(CurrentMenu.X + SettingsButton.Line.X + (CurrentMenu.WidthOffset * 2.5 ~= 0 and CurrentMenu.WidthOffset * 2.5 or 60), CurrentMenu.Y + SettingsButton.Line.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 300, 3, Style.Line[1], Style.Line[2], Style.Line[3], Style.Line[4])
                    end
                else
                    RenderRectangle(CurrentMenu.X + SettingsButton.Line.X + (CurrentMenu.WidthOffset * 2.5 ~= 0 and CurrentMenu.WidthOffset * 2.5 or 60), CurrentMenu.Y + SettingsButton.Line.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 300, 3, 255, 255, 255, 170)
                end

                RageUI.ItemOffset = RageUI.ItemOffset + SettingsButton.Rectangle.Height
                if (CurrentMenu.Index == Option) then
                    if (RageUI.LastControl) then
                        CurrentMenu.Index = Option - 1
                        if (CurrentMenu.Index < 1) then
                            CurrentMenu.Index = RageUI.CurrentMenu.Options
                        end
                    else
                        CurrentMenu.Index = Option + 1
                    end
                end
            end
            RageUI.Options = RageUI.Options + 1
        end
    end
end