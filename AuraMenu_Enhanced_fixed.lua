local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local MPS = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local okVU, VU = pcall(game.GetService, game, "VirtualUser")

local lp = Players.LocalPlayer
local pgui = lp:WaitForChild("PlayerGui")
local genv = (getgenv and getgenv()) or _G
if genv.AuraUnload then pcall(genv.AuraUnload) end
if pgui:FindFirstChild("AuraMenu") then pgui.AuraMenu:Destroy() end
if SoundService:FindFirstChild("AuraSound") then SoundService.AuraSound:Destroy() end
for _, v in ipairs(Lighting:GetChildren()) do if v.Name == "AuraBlur" or v.Name == "AuraEnvBloom" or v.Name == "AuraEnvColor" or v.Name == "AuraEnvRays" then v:Destroy() end end

local WIN_W, WIN_H, TOP, SB = 420, 270, 36, 96
local EASE, DIR = Enum.EasingStyle, Enum.EasingDirection
local WHITE = Color3.new(1, 1, 1)
local C = {
	bg = Color3.fromRGB(13, 13, 20), bar = Color3.fromRGB(19, 19, 28),
	card = Color3.fromRGB(25, 25, 37), card2 = Color3.fromRGB(38, 38, 55),
	card3 = Color3.fromRGB(31, 31, 46), border = Color3.fromRGB(73, 73, 104),
	text = Color3.fromRGB(238, 238, 248), sub = Color3.fromRGB(140, 140, 168),
	off = Color3.fromRGB(52, 52, 72), bad = Color3.fromRGB(255, 95, 105), good = Color3.fromRGB(80, 225, 140),
	warn = Color3.fromRGB(255, 190, 80), softBlue = Color3.fromRGB(95, 180, 255),
}
local accent = Color3.fromRGB(130, 100, 255)
local reg, conns, trReg, ctl = {}, {}, {}, {}
local rainbow, hue = false, 0
local lang = "Русский"
local cfg = {}

local EN = {
	["Музыка"] = "Music", ["Эффекты"] = "Effects", ["Визуал"] = "Visuals", ["Разное"] = "Misc", ["Настройки"] = "Settings",
	["ПЛЕЕР"] = "PLAYER", ["Вставьте ID песни"] = "Paste song ID", ["Играть"] = "Play", ["Пауза"] = "Pause", ["Стоп"] = "Stop",
	["-10с"] = "-10s", ["+10с"] = "+10s", ["Трек"] = "Track", ["Повтор трека"] = "Repeat track",
	["СКОРОСТЬ И ТОНАЛЬНОСТЬ"] = "SPEED & PITCH", ["Скорость"] = "Speed", ["Менять тон со скоростью"] = "Pitch follows speed",
	["Тональность"] = "Pitch", ["пт"] = "st", ["ГРОМКОСТЬ"] = "VOLUME", ["Усиление"] = "Gain", ["Сбросить всё"] = "Reset all",
	["ПРЕСЕТЫ"] = "PRESETS", ["Сброс"] = "Reset", ["ЭКВАЛАЙЗЕР"] = "EQUALIZER", ["Низкие"] = "Low", ["Средние"] = "Mid",
	["Высокие"] = "High", ["ПРОСТРАНСТВО"] = "SPACE", ["Реверберация"] = "Reverb", ["Эхо"] = "Echo",
	["ОТОБРАЖЕНИЕ"] = "DISPLAY", ["Подсветка игроков"] = "Player highlight", ["Скелет"] = "Skeleton", ["Имена"] = "Names",
	["Дистанция"] = "Distance", ["Дальность"] = "Range", ["Стиль"] = "Style", ["Контур"] = "Outline", ["Заливка"] = "Fill",
	["Градиент"] = "Gradient", ["ст."] = "studs", ["ОБЩЕЕ"] = "GENERAL", ["Анти-АФК"] = "Anti-AFK", ["Показывать FPS"] = "Show FPS",
	["Авто-перезаход"] = "Auto rejoin", ["Поле зрения"] = "Field of view", ["Язык"] = "Language",
	["Сохранить конфиг"] = "Save config", ["Загрузить конфиг"] = "Load config", ["ЦВЕТ АКЦЕНТА"] = "ACCENT COLOR",
	["Оттенок"] = "Hue", ["ОКНО"] = "WINDOW", ["Прозрачность"] = "Transparency", ["Размер меню"] = "Menu size",
	["Размытие фона"] = "Background blur", ["Сбросить позицию"] = "Reset position", ["Выгрузить меню"] = "Unload menu",
	["Ничего не играет"] = "Nothing playing", ["Введите ID и нажмите «Играть»"] = "Enter an ID and press Play",
	["Введите числовой ID"] = "Enter a numeric ID", ["Загрузка..."] = "Loading...", ["Играет"] = "Playing",
	["На паузе"] = "Paused", ["Остановлено"] = "Stopped", ["Трек закончился"] = "Track ended", ["Ошибка"] = "Error",
	["Не загрузилось: ID закрыт или неверный"] = "Failed to load: ID is private or invalid",
	["Трек загружен"] = "Track loaded", ["Не удалось загрузить ID"] = "Could not load ID", ["Пресет: "] = "Preset: ",
	["Всё сброшено"] = "Everything reset", ["Акцент изменён"] = "Accent changed", ["Радужный режим"] = "Rainbow mode",
	["Радуга выключена"] = "Rainbow off", ["Конфиг сохранён"] = "Config saved", ["Сохранение недоступно"] = "Saving unavailable",
	["Конфиг загружен"] = "Config loaded", ["Конфиг не найден"] = "Config not found", ["Переподключение..."] = "Reconnecting...",
	["AURA загружено"] = "AURA loaded",
	["ПОИСК ПО НАЗВАНИЮ"] = "SEARCH BY TITLE", ["Название песни"] = "Song title",
	["Найти"] = "Search", ["Поиск..."] = "Searching...", ["Введите хотя бы 2 символа"] = "Enter at least 2 characters",
	["Ничего не найдено"] = "No results found", ["Поиск недоступен в этой среде"] = "Search is unavailable here; try an audio ID",
	["Пуск / пауза"] = "Play / Pause", ["Ночной"] = "Night", ["Замедленный"] = "Slowed", ["Бас"] = "Bass",
	["Золотой час"] = "Golden Hour", ["Полночь"] = "Midnight", ["Ужас"] = "Horror",
	["Под водой"] = "Underwater", ["Научная фантастика"] = "Sci-Fi", ["Северное сияние"] = "Aurora",
	["Отключить эффекты"] = "Disable effects", ["ВИЗУАЛЬНЫЕ ЭФФЕКТЫ"] = "VISUAL EFFECTS",
	["Мягкое свечение и цвет"] = "Soft bloom & color", ["Интенсивность эффекта"] = "Effect intensity",
	["ПРЕСЕТЫ ОКРУЖЕНИЯ"] = "ENVIRONMENT PRESETS", ["Толщина скелета"] = "Skeleton thickness",
	["Эффект сброшен"] = "Effect reset", ["Активен эффект: "] = "Active effect: ",
	["ОЧЕРЕДЬ"] = "QUEUE", ["Очередь пуста"] = "Queue is empty", ["Очередь"] = "Queue",
	["В очереди"] = "In queue", ["Очистить очередь"] = "Clear queue", ["Добавить в очередь"] = "Add to queue",
	["Играть сейчас"] = "Play now", ["Удалить"] = "Remove", ["Автор неизвестен"] = "Unknown artist",
	["ВИЗУАЛЬНЫЙ ESP"] = "VISUAL ESP", ["Рамка игрока"] = "Player box", ["Полоса здоровья"] = "Health bar",
	["Трассеры"] = "Tracers", ["Проверка команды"] = "Team check", ["Здоровье в имени"] = "Health in label",
	["ЦВЕТ И ПЛАВНОСТЬ"] = "COLOR & SMOOTHNESS", ["Плавность анимаций"] = "Animation smoothness",
	["Яркость ESP"] = "ESP brightness", ["Размер подписей"] = "Label size", ["Толщина рамки"] = "Box thickness",
	["ИНФОРМАЦИЯ О ПЛЕЕРЕ"] = "PLAYER INFO", ["Треков в очереди"] = "Tracks queued",
	["Очередь обновлена"] = "Queue updated", ["Добавлено в очередь"] = "Added to queue",
	["Авто-скрытие после выбора"] = "Auto-hide after starting playback", ["Скорость анимаций"] = "Animation speed",
	["Сбросить конфиг"] = "Reset settings", ["Всё включить"] = "Enable all", ["Всё скрыть"] = "Hide all",
	["Уже в очереди"] = "Already queued", ["Список очищен"] = "List cleared",
	["ОКРУЖЕНИЕ"] = "ENVIRONMENT", ["Мягкое свечение"] = "Soft bloom", ["Сила свечения"] = "Bloom strength",
	["Цветовой стиль"] = "Color style", ["Солнечные лучи"] = "Sun rays", ["Кино"] = "Cinematic", ["Яркий"] = "Vivid",
	["Микшер"] = "Mixer", ["Быстрые настройки"] = "Quick controls", ["Тихо"] = "Quiet",
	["Обычный"] = "Normal", ["Громко"] = "Loud", ["Максимум"] = "Maximum",
	["Список результатов"] = "Search results", ["Поиск аудио Roblox"] = "Roblox audio search",
	["Поиск выполняется через AssetService"] = "Search uses AssetService", ["Сменить трек"] = "Change track",
	["Отмена"] = "Cancel", ["Включено"] = "Enabled", ["Выключено"] = "Disabled",
}

local function T(s)
	if lang == "English" then return EN[s] or s end
	return s
end

local function bind(o, s, prop)
	prop = prop or "Text"
	o[prop] = T(s)
	trReg[#trReg + 1] = function() o[prop] = T(s) end
end

local function setLang(i)
	lang = i == 2 and "English" or "Русский"
	cfg.lang = i
	for _, f in ipairs(trReg) do f() end
	for _, o in pairs(ctl) do if o.Refresh then o.Refresh() end end
end

local function cn(sig, fn)
	local c = sig:Connect(fn)
	conns[#conns + 1] = c
	return c
end

function __AuraFix_tw(o, p, t, st, dr)
	local speed = tonumber(cfg.animSpeedFactor) or 1
	speed = math.clamp(speed, .5, 1.5)
	local duration = math.max(.015, (t or .2) / speed)
	__AuraFix_activeTweens = __AuraFix_activeTweens or setmetatable({}, {__mode = "k"})
	local records = __AuraFix_activeTweens[o]
	if not records then records = {}; __AuraFix_activeTweens[o] = records end
	for i = #records, 1, -1 do
		local rec, overlap = records[i], false
		for property in pairs(p) do if rec.props[property] then overlap = true; break end end
		if overlap then table.remove(records, i); pcall(function() rec.tween:Cancel() end) end
	end
	local tween = TS:Create(o, TweenInfo.new(duration, st or EASE.Quint, dr or DIR.Out), p)
	local record = {tween = tween, props = p}
	records[#records + 1] = record
	tween.Completed:Connect(function()
		local current = __AuraFix_activeTweens and __AuraFix_activeTweens[o]
		if current then
			for i = #current, 1, -1 do if current[i] == record then table.remove(current, i) end end
			if #current == 0 then __AuraFix_activeTweens[o] = nil end
		end
	end)
	tween:Play()
	return tween
end
local tw = __AuraFix_tw

local lo = 0
local function new(class, props, parent)
	local o = Instance.new(class)
	if o:IsA("GuiObject") then o.BorderSizePixel = 0 end
	if class == "UIListLayout" then o.SortOrder = Enum.SortOrder.LayoutOrder end
	for k, v in pairs(props) do o[k] = v end
	if parent then
		if o:IsA("GuiObject") and parent:FindFirstChildOfClass("UIListLayout") then lo += 1; o.LayoutOrder = lo end
		o.Parent = parent
	end
	return o
end

local function round(o, r) new("UICorner", {CornerRadius = UDim.new(0, r or 8)}, o) end
local function stroke(p, th, col, tr)
	return new("UIStroke", {Thickness = th, Color = col, Transparency = tr, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, p)
end
local function isPress(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end

local function acc(o, prop, get)
	get = get or function() return accent end
	o[prop] = get()
	reg[#reg + 1] = function(instant)
		if instant then o[prop] = get() else tw(o, {[prop] = get()}, .35) end
	end
end

local function light(c) return c:Lerp(WHITE, .65) end
local function dark(c) return c:Lerp(Color3.new(0, 0, 0), .8) end
local function shift(c)
	local h, s, v = c:ToHSV()
	return Color3.fromHSV((h + .18) % 1, s, v)
end
local function loop(o, props, t)
	TS:Create(o, TweenInfo.new(t, EASE.Linear, DIR.InOut, -1), props):Play()
end

local function grad(parent, mk, props)
	local g = new("UIGradient", props or {}, parent)
	g.Color = mk()
	reg[#reg + 1] = function() g.Color = mk() end
	return g
end

local function lbl(parent, text, size, color, extra)
	local p = {BackgroundTransparency = 1, TextSize = size or 13, TextColor3 = color or C.text, Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Left, Size = UDim2.fromScale(1, 1), TextTruncate = Enum.TextTruncate.AtEnd}
	for k, v in pairs(extra or {}) do p[k] = v end
	local o = new("TextLabel", p, parent)
	if text ~= "" then bind(o, text) end
	return o
end

local function press(b, flat)
	local s = new("UIScale", {Name = "Pop"}, b)
	b.ClipsDescendants = true
	local cr = b:FindFirstChildOfClass("UICorner")
	local ov = new("Frame", {BackgroundColor3 = WHITE, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 4}, b)
	if cr then new("UICorner", {CornerRadius = cr.CornerRadius}, ov) end
	cn(b.MouseEnter, function()
		tw(ov, {BackgroundTransparency = .88}, .18, EASE.Sine)
		if not flat then tw(s, {Scale = 1.025}, .18, EASE.Quad) end
	end)
	cn(b.MouseLeave, function()
		tw(ov, {BackgroundTransparency = 1}, .24, EASE.Sine)
		if not flat then tw(s, {Scale = 1}, .2, EASE.Quad) end
	end)
	cn(b.InputBegan, function(i)
		if not isPress(i) then return end
		tw(s, {Scale = .94}, .09, EASE.Quad)
		local sz = b.AbsoluteSize
		if flat or sz.X < 1 then return end
		local k = math.max(sz.X, sz.Y) * 2.2
		local rp = new("Frame", {BackgroundColor3 = WHITE, BackgroundTransparency = .75, AnchorPoint = Vector2.new(.5, .5),
			Position = UDim2.fromScale((i.Position.X - b.AbsolutePosition.X) / sz.X, (i.Position.Y - b.AbsolutePosition.Y) / sz.Y),
			Size = UDim2.fromOffset(0, 0), ZIndex = 5}, b)
		round(rp, 200)
		tw(rp, {Size = UDim2.fromOffset(k, k), BackgroundTransparency = 1}, .55).Completed:Connect(function() rp:Destroy() end)
	end)
	cn(b.InputEnded, function(i) if isPress(i) then tw(s, {Scale = 1}, .24, EASE.Back) end end)
end

local CFG_FILE = "AuraMenu.json"
local function loadCfg()
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CFG_FILE)) end)
	if ok and type(data) == "table" then cfg = data return true end
	return false
end
local function saveCfg()
	return pcall(function() writefile(CFG_FILE, HttpService:JSONEncode(cfg)) end)
end
loadCfg()
if type(cfg.accent) == "table" and cfg.accent[3] then accent = Color3.new(cfg.accent[1], cfg.accent[2], cfg.accent[3]) end
rainbow = cfg.rainbow == true
lang = cfg.lang == 2 and "English" or "Русский"

local gui = new("ScreenGui", {Name = "AuraMenu", ResetOnSpawn = false, IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100}, pgui)
local blur = new("BlurEffect", {Name = "AuraBlur", Size = 0}, Lighting)
local blurOn = true
local skelLayer = new("Frame", {Name = "ESP", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}, gui)

local toastF
local function toast(text, col)
	if cfg.hints == false then return end
	text = T(text)
	if toastF then toastF:Destroy() end
	local f = new("Frame", {AnchorPoint = Vector2.new(.5, 0), Position = UDim2.new(.5, 0, 0, -50), Size = UDim2.fromOffset(0, 34),
		AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = C.bar, ZIndex = 20}, gui)
	toastF = f
	round(f, 17)
	new("UIPadding", {PaddingLeft = UDim.new(0, 30), PaddingRight = UDim.new(0, 18)}, f)
	stroke(f, 1.5, accent, .3)
	local dot = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.new(0, -15, .5, 0), Size = UDim2.fromOffset(8, 8),
		BackgroundColor3 = col or accent, ZIndex = 21}, f)
	round(dot, 4)
	TS:Create(dot, TweenInfo.new(.6, EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .6}):Play()
	new("TextLabel", {BackgroundTransparency = 1, Text = text, TextSize = 13, TextColor3 = C.text, Font = Enum.Font.GothamMedium,
		Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, ZIndex = 21}, f)
	tw(f, {Position = UDim2.new(.5, 0, 0, 14)}, .55, EASE.Back)
	task.delay(2.4, function()
		if f.Parent then
			tw(f, {Position = UDim2.new(.5, 0, 0, -50)}, .4, EASE.Quad, DIR.In).Completed:Connect(function() f:Destroy() end)
		end
	end)
end

local function drag(handle, target, bounds)
	local st = {moved = false}
	local active, inp, origin, start
	cn(handle.InputBegan, function(i)
		if isPress(i) then
			active, inp, origin, start, st.moved = true, i, i.Position, target.Position, false
			i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then active = false end end)
		end
	end)
	cn(UIS.InputChanged, function(i)
		if active and (i == inp or i.UserInputType == Enum.UserInputType.MouseMovement) then
			local d = i.Position - origin
			if d.Magnitude > 6 then st.moved = true end
			if not st.moved then return end
			local W, H = gui.AbsoluteSize.X, gui.AbsoluteSize.Y
			local x0, x1, y0, y1 = bounds(W, H)
			local nx = math.clamp(start.X.Scale * W + start.X.Offset + d.X, x0, x1) - start.X.Scale * W
			local ny = math.clamp(start.Y.Scale * H + start.Y.Offset + d.Y, y0, y1) - start.Y.Scale * H
			target.Position = UDim2.new(start.X.Scale, nx, start.Y.Scale, ny)
		end
	end)
	return st
end

local cam0 = workspace.CurrentCamera
local vp = cam0 and cam0.ViewportSize or Vector2.new(800, 400)
if vp.Y < 150 then vp = Vector2.new(800, 400) end
local baseScale = math.clamp(math.min((vp.Y - 40) / WIN_H, (vp.X - 16) / WIN_W), .52, 1)
local baseGT, opened, collapsed, openTok = 0, false, false, 0
local startPos = UDim2.new(.5, 0, 0, math.max(6, (vp.Y - WIN_H * baseScale) / 2))

local holder = new("Frame", {Name = "Holder", Size = UDim2.fromOffset(WIN_W, WIN_H), AnchorPoint = Vector2.new(.5, 0),
	Position = startPos, BackgroundTransparency = 1}, gui)
local main = new("CanvasGroup", {AnchorPoint = Vector2.new(.5, 0), Position = UDim2.fromScale(.5, 0), Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = C.bg, GroupTransparency = 1, Visible = false, ClipsDescendants = true}, holder)
round(main, 12)
local mscale = new("UIScale", {Scale = baseScale}, main)
local mstroke = stroke(main, 2, WHITE, .15)
loop(grad(mstroke, function() return ColorSequence.new({ColorSequenceKeypoint.new(0, accent), ColorSequenceKeypoint.new(.5, dark(accent)), ColorSequenceKeypoint.new(1, accent)}) end), {Rotation = 360}, 5)

local tint = new("Frame", {Size = UDim2.fromScale(1, 1)}, main)
acc(tint, "BackgroundColor3")
new("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, .88), NumberSequenceKeypoint.new(1, 1)})}, tint)

for k = 1, 2 do
	local o = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Size = UDim2.fromOffset(220, 220), BackgroundTransparency = .93,
		Position = UDim2.fromScale(k == 1 and .1 or .95, k == 1 and .05 or .98)}, main)
	round(o, 110); acc(o, "BackgroundColor3")
	TS:Create(o, TweenInfo.new(7 + k * 2, EASE.Sine, DIR.InOut, -1, true),
		{Position = UDim2.fromScale(k == 1 and .3 or .75, k == 1 and .25 or .8), BackgroundTransparency = .97}):Play()
end

for _ = 1, 14 do
	local sz, d = math.random(3, 6), math.random(60, 120) / 10
	local pt = new("Frame", {BackgroundTransparency = .9, Size = UDim2.fromOffset(sz, sz), AnchorPoint = Vector2.new(.5, .5),
		Position = UDim2.fromScale(math.random(), 1.05)}, main)
	round(pt, 3); acc(pt, "BackgroundColor3")
	TS:Create(pt, TweenInfo.new(d, EASE.Linear, DIR.Out, -1), {Position = UDim2.fromScale(math.random(), -.05)}):Play()
	TS:Create(pt, TweenInfo.new(d / 2, EASE.Sine, DIR.InOut, -1, true), {BackgroundTransparency = .55}):Play()
end

local top = new("Frame", {Size = UDim2.new(1, 0, 0, TOP), BackgroundColor3 = C.bar}, main)
local title = lbl(top, "AURA", 16, WHITE, {Position = UDim2.fromOffset(12, 0), Size = UDim2.fromOffset(56, TOP), Font = Enum.Font.GothamBlack})
local credit = lbl(top, "by Claude", 10, C.sub, {Position = UDim2.fromOffset(70, 1), Size = UDim2.fromOffset(76, TOP), Font = Enum.Font.GothamMedium})
loop(grad(title, function() return ColorSequence.new({ColorSequenceKeypoint.new(0, accent), ColorSequenceKeypoint.new(.5, light(accent)), ColorSequenceKeypoint.new(1, accent)}) end,
	{Offset = Vector2.new(-.5, 0)}), {Offset = Vector2.new(.5, 0)}, 1.8)
local line = new("Frame", {Position = UDim2.new(0, 0, 1, -2), Size = UDim2.new(1, 0, 0, 2)}, top)
acc(line, "BackgroundColor3")
loop(new("UIGradient", {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, .9), NumberSequenceKeypoint.new(.5, 0), NumberSequenceKeypoint.new(1, .9)}),
	Offset = Vector2.new(-1, 0)}, line), {Offset = Vector2.new(1, 0)}, 2.2)

local mini = {}
local miniF = new("Frame", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -84, .5, 0), Size = UDim2.fromOffset(16, 12)}, top)
for k = 1, 3 do
	local b = new("Frame", {AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, (k - 1) * 6, 1, 0), Size = UDim2.fromOffset(4, 3)}, miniF)
	round(b, 2); acc(b, "BackgroundColor3")
	mini[k] = {f = b, h = 3}
end

local function topBtn(txt, n)
	local b = new("TextButton", {Text = txt, Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = C.text,
		AutoButtonColor = false, BackgroundColor3 = C.card2, Size = UDim2.fromOffset(28, 22),
		AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -8 - (n - 1) * 34, .5, -1)}, top)
	round(b, 6); press(b)
	return b
end
local closeB, colB = topBtn("×", 1), topBtn("–", 2)
cn(closeB.MouseEnter, function() tw(closeB, {BackgroundColor3 = C.bad}, .2) end)
cn(closeB.MouseLeave, function() tw(closeB, {BackgroundColor3 = C.card2}, .25) end)

drag(top, holder, function(W, H) return 40, W - 40, 0, H - 40 end)

local side = new("Frame", {Position = UDim2.fromOffset(6, TOP + 8), Size = UDim2.new(0, SB, 1, -TOP - 14), BackgroundTransparency = 1}, main)
new("Frame", {Position = UDim2.fromOffset(SB + 7, TOP + 14), Size = UDim2.new(0, 1, 1, -TOP - 28), BackgroundColor3 = WHITE, BackgroundTransparency = .92}, main)
local CPOS = UDim2.fromOffset(SB + 12, TOP + 8)
local content = new("CanvasGroup", {Position = CPOS, Size = UDim2.new(1, -SB - 18, 1, -TOP - 14), BackgroundTransparency = 1}, main)

local function setOpen(v)
	if opened == v then return end
	opened = v; openTok += 1
	local my = openTok
	if v then
		main.Visible = true
		tw(blur, {Size = blurOn and 14 or 0}, .5)
		mscale.Scale = baseScale * .86
		tw(main, {GroupTransparency = baseGT}, .28)
		tw(mscale, {Scale = baseScale}, .5, EASE.Back)
	else
		tw(main, {GroupTransparency = 1}, .2)
		tw(blur, {Size = 0}, .3)
		tw(mscale, {Scale = baseScale * .86}, .2, EASE.Quad, DIR.In)
		task.delay(.22, function() if openTok == my then main.Visible = false end end)
	end
end

local function setCollapsed(v)
	collapsed = v
	colB.Text = v and "+" or "–"
	tw(main, {Size = v and UDim2.new(1, 0, 0, TOP) or UDim2.fromScale(1, 1)}, .45, EASE.Quint)
end
cn(closeB.Activated, function() setOpen(false) end)
cn(colB.Activated, function() setCollapsed(not collapsed) end)

local fab = new("TextButton", {Text = "A", Font = Enum.Font.GothamBlack, TextSize = 20, TextColor3 = WHITE,
	AutoButtonColor = false, Size = UDim2.fromOffset(46, 46), Position = UDim2.new(0, 14, .5, -23)}, gui)
round(fab, 23); acc(fab, "BackgroundColor3"); press(fab, true)
local fs = stroke(fab, 2, accent, .5); acc(fs, "Color")
TS:Create(fs, TweenInfo.new(1.4, EASE.Sine, DIR.InOut, -1, true), {Thickness = 6, Transparency = .9}):Play()
local fabDrag = drag(fab, fab, function(W, H) return 0, W - 46, 0, H - 46 end)
cn(fab.Activated, function()
	if fabDrag.moved then return end
	setOpen(not opened)
	tw(fab, {Rotation = fab.Rotation + 360}, .7, EASE.Back)
end)

local cols = {Color3.fromRGB(130, 100, 255), Color3.fromRGB(0, 200, 255), Color3.fromRGB(255, 85, 150),
	Color3.fromRGB(60, 220, 130), Color3.fromRGB(255, 160, 50), Color3.fromRGB(255, 75, 85)}
local swb = {}
local function mark(idx)
	for k, b in pairs(swb) do tw(b.S, {Transparency = k == idx and 0 or 1}, .25) end
end
local function setAccent(col, idx, instant)
	accent = col
	cfg.accent = {col.R, col.G, col.B}
	for _, f in ipairs(reg) do f(instant) end
	mark(idx)
end

local function card(p, h)
	local f = new("Frame", {Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = C.card}, p)
	round(f, 8)
	return f, stroke(f, 1, WHITE, .93)
end

local function hov(b, f, st)
	cn(b.MouseEnter, function() tw(st, {Transparency = .75}, .2); tw(f, {BackgroundColor3 = C.card:Lerp(WHITE, .035)}, .2) end)
	cn(b.MouseLeave, function() tw(st, {Transparency = .93}, .25); tw(f, {BackgroundColor3 = C.card}, .25) end)
end

local function section(p, text)
	local f = new("Frame", {Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1}, p)
	local bar = new("Frame", {AnchorPoint = Vector2.new(0, .5), Position = UDim2.new(0, 1, .5, 1), Size = UDim2.fromOffset(3, 10)}, f)
	round(bar, 2); acc(bar, "BackgroundColor3")
	lbl(f, text, 11, C.sub, {Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -10, 1, 0), Font = Enum.Font.GothamBold})
	return f
end

local function row(p, h)
	local f = new("Frame", {Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 1}, p)
	new("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6)}, f)
	return f
end

local function button(p, text, cb, primary, size)
	local b = new("TextButton", {Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = C.text, AutoButtonColor = false,
		BackgroundColor3 = C.card2, Size = size or UDim2.new(1, 0, 0, 32)}, p)
	bind(b, text)
	round(b, 8); press(b)
	if primary then acc(b, "BackgroundColor3") end
	if cb then cn(b.Activated, cb) end
	return b
end

local function toggle(p, text, def, cb, key)
	local originalDef = def and true or false
	local f, st = card(p, 36)
	lbl(f, text, 13, nil, {Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -60, 1, 0)})
	local b = new("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}, f)
	local fromCfg = key and cfg[key] ~= nil
	local on = def and true or false
	if fromCfg then on = cfg[key] and true or false end
	local sw = new("Frame", {AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -10, .5, 0), Size = UDim2.fromOffset(38, 20)}, f)
	round(sw, 10)
	acc(sw, "BackgroundColor3", function() return on and accent or C.off end)
	local knob = new("Frame", {BackgroundColor3 = WHITE, AnchorPoint = Vector2.new(0, .5), Size = UDim2.fromOffset(14, 14), Position = UDim2.new(0, 3, .5, 0)}, sw)
	round(knob, 7)
	local held = false
	local function place(fast)
		local w = held and 18 or 14
		local props = {Size = UDim2.fromOffset(w, 14), Position = UDim2.new(0, on and 35 - w or 3, .5, 0)}
		if fast then for k, v in pairs(props) do knob[k] = v end else tw(knob, props, .3, EASE.Back) end
	end
	place(true)
	local obj = {Default = originalDef}
	function obj.Set(v, silent)
		on = v and true or false
		if key then cfg[key] = on end
		tw(sw, {BackgroundColor3 = on and accent or C.off}, .2)
		place()
		if not silent and cb then cb(on) end
	end
	cn(b.InputBegan, function(i) if isPress(i) then held = true; place() end end)
	cn(b.InputEnded, function(i) if isPress(i) then held = false; place() end end)
	cn(b.Activated, function() obj.Set(not on) end)
	hov(b, f, st)
	if key then ctl[key] = obj; cfg[key] = on end
	if fromCfg and cb then cb(on) end
	return obj
end

local function slider(p, text, min, max, def, fmt, cb, step, key, commit)
	local originalDef = def
	local f, st = card(p, 50)
	lbl(f, text, 13, nil, {Position = UDim2.fromOffset(10, 5), Size = UDim2.new(1, -90, 0, 20)})
	local val = lbl(f, "", 12, C.sub, {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 5),
		Size = UDim2.fromOffset(76, 20), TextXAlignment = Enum.TextXAlignment.Right})
	local hit = new("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 26), Size = UDim2.new(1, 0, 0, 24)}, f)
	local track = new("Frame", {BackgroundColor3 = C.card2, AnchorPoint = Vector2.new(0, .5),
		Position = UDim2.new(0, 10, .5, 0), Size = UDim2.new(1, -20, 0, 6)}, hit)
	round(track, 3)
	local fill = new("Frame", {BackgroundColor3 = WHITE, Size = UDim2.fromScale(0, 1)}, track)
	round(fill, 3)
	grad(fill, function() return ColorSequence.new(accent:Lerp(Color3.new(0, 0, 0), .3), accent) end)
	local knob = new("Frame", {BackgroundColor3 = WHITE, AnchorPoint = Vector2.new(.5, .5), Size = UDim2.fromOffset(14, 14),
		Position = UDim2.fromScale(0, .5), ZIndex = 2}, track)
	round(knob, 7)
	local ks = stroke(knob, 0, accent, .55); acc(ks, "Color")
	local fromCfg = key and cfg[key] ~= nil
	if fromCfg then def = cfg[key] end
	local obj = {Label = val, Dragging = false, Default = originalDef}
	local cur = def
	local function set(v, silent, instant)
		v = math.clamp(v, min, max)
		if step then v = math.floor(v / step + .5) * step end
		cur = v
		if key then cfg[key] = v end
		local a = (v - min) / (max - min)
		if instant then
			fill.Size = UDim2.fromScale(a, 1); knob.Position = UDim2.fromScale(a, .5)
		else
			tw(fill, {Size = UDim2.fromScale(a, 1)}, .12, EASE.Quad)
			tw(knob, {Position = UDim2.fromScale(a, .5)}, .12, EASE.Quad)
		end
		local s = fmt and fmt(v) or tostring(v)
		if val.Text ~= s then val.Text = s end
		if not silent and cb and not (commit and obj.Dragging) then cb(v) end
	end
	local function fromX(x)
		set(min + (max - min) * math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1))
	end
	cn(hit.InputBegan, function(i)
		if not isPress(i) then return end
		obj.Dragging = true
		local sf = f:FindFirstAncestorOfClass("ScrollingFrame")
		if sf then sf.ScrollingEnabled = false end
		fromX(i.Position.X)
		tw(knob, {Size = UDim2.fromOffset(19, 19)}, .15); tw(ks, {Thickness = 5}, .2); tw(val, {TextColor3 = accent}, .15)
		local conn
		conn = UIS.InputChanged:Connect(function(c)
			if c == i or c.UserInputType == Enum.UserInputType.MouseMovement then fromX(c.Position.X) end
		end)
		i.Changed:Connect(function()
			if i.UserInputState == Enum.UserInputState.End then
				conn:Disconnect(); obj.Dragging = false
				if sf then sf.ScrollingEnabled = true end
				if commit and cb then cb(cur) end
				tw(knob, {Size = UDim2.fromOffset(14, 14)}, .25, EASE.Back); tw(ks, {Thickness = 0}, .3); tw(val, {TextColor3 = C.sub}, .3)
			end
		end)
	end)
	hov(hit, f, st)
	obj.Set = set
	function obj.Refresh() set(cur, true, true) end
	set(def, not fromCfg, true)
	if key then ctl[key] = obj end
	return obj
end

local function segment(p, text, opts, cb, def, key)
	local originalDef = def or 1
	local f, st = card(p, 36)
	lbl(f, text, 13, nil, {Position = UDim2.fromOffset(10, 0), Size = UDim2.new(.34, -10, 1, 0)})
	local seg = new("Frame", {BackgroundColor3 = C.card2, AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -8, .5, 0), Size = UDim2.new(.66, -12, 0, 24)}, f)
	round(seg, 6)
	local n = #opts
	local ind = new("Frame", {Size = UDim2.new(1 / n, -4, 1, -4), Position = UDim2.new(0, 2, 0, 2)}, seg)
	round(ind, 5); acc(ind, "BackgroundColor3")
	local btns, cur = {}, 1
	local obj = {Default = originalDef}
	function obj.Set(i, silent, fast)
		i = math.clamp(math.floor(i + .5), 1, n)
		cur = i
		if key then cfg[key] = i end
		local pos = UDim2.new((i - 1) / n, 2, 0, 2)
		if fast then ind.Position = pos else tw(ind, {Position = pos}, .35, EASE.Back) end
		for k, b in ipairs(btns) do
			local c = k == i and WHITE or C.sub
			if fast then b.TextColor3 = c else tw(b, {TextColor3 = c}, .2) end
		end
		if not silent and cb then cb(i) end
	end
	for k, o in ipairs(opts) do
		local b = new("TextButton", {Font = Enum.Font.GothamBold, TextSize = n > 2 and 10 or 11, TextColor3 = C.sub, BackgroundTransparency = 1,
			AutoButtonColor = false, Position = UDim2.fromScale((k - 1) / n, 0), Size = UDim2.fromScale(1 / n, 1), ZIndex = 2}, seg)
		bind(b, o)
		btns[k] = b
		cn(b.Activated, function() if cur ~= k then obj.Set(k) end end)
		cn(b.MouseEnter, function() tw(st, {Transparency = .75}, .2) end)
		cn(b.MouseLeave, function() tw(st, {Transparency = .93}, .25) end)
	end
	local fromCfg = key and cfg[key] ~= nil
	obj.Set(fromCfg and cfg[key] or def or 1, not fromCfg, true)
	if key then ctl[key] = obj end
	return obj
end

local pages, order = {}, {"Музыка", "Эффекты", "Визуал", "Разное", "Настройки"}
local function page(name)
	local p = new("ScrollingFrame", {Name = name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ScrollBarThickness = 3,
		CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
		Visible = false, ScrollBarImageTransparency = .3}, content)
	new("UIListLayout", {Padding = UDim.new(0, 6)}, p)
	new("UIPadding", {PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingTop = UDim.new(0, 2)}, p)
	acc(p, "ScrollBarImageColor3")
	pages[name] = p
	return p
end

local function fmtT(s) s = math.floor(s); return string.format("%d:%02d", s // 60, s % 60) end

local sound = new("Sound", {Name = "AuraSound", Volume = 1}, SoundService)
local pitch = new("PitchShiftSoundEffect", {Octave = 1, Enabled = false}, sound)
local eq = new("EqualizerSoundEffect", {LowGain = 0, MidGain = 0, HighGain = 0}, sound)
local reverb = new("ReverbSoundEffect", {Enabled = false, DecayTime = 2.8, DryLevel = -2, WetLevel = -4}, sound)
local echo = new("EchoSoundEffect", {Enabled = false, Delay = .35, Feedback = .45, DryLevel = 0, WetLevel = -6}, sound)

local S = {speed = 1, semi = 0, tape = true, db = 0}
local function applyAudio()
	sound.PlaybackSpeed = S.speed
	local target = 2 ^ (S.semi / 12) * (S.tape and S.speed or 1)
	local oct = math.clamp(target / S.speed, .5, 2)
	pitch.Octave = oct
	pitch.Enabled = math.abs(oct - 1) > .001
	sound.Volume = math.min(10 ^ (S.db / 20), 10)
end

local nameL, statusL, histBox, box, play
local history, playTok = {}, 0
local knownTitles = {}
local queueItems = {}
local queueList, queueStatus, searchBox, searchStatus, searchResults
local searchToken = 0
local currentSearchTerm = ""
local searchResultCount = 0
local queueAutoPlay = true
local visualizerStyle = 1
local musicAccentPulse = true
local touched, trackOK, endedF = false, false, false
local function setStatus(t, col)
	statusL.Text = t
	tw(statusL, {TextColor3 = col or C.sub}, .25)
end
local function idle()
	if touched then return end
	nameL.Text = T("Ничего не играет")
	setStatus(T("Введите ID и нажмите «Играть»"))
end

local function addHistory(id)
	local i = table.find(history, id); if i then table.remove(history, i) end
	table.insert(history, 1, id); if #history > 3 then table.remove(history) end
	for _, c in ipairs(histBox:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
	for _, v in ipairs(history) do
		local b = new("TextButton", {Text = v, Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.text,
			AutoButtonColor = false, BackgroundColor3 = C.card, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0)}, histBox)
		round(b, 6); press(b)
		stroke(b, 1, WHITE, .9)
		new("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}, b)
		local sc = b:FindFirstChild("Pop")
		sc.Scale = .6
		tw(sc, {Scale = 1}, .45, EASE.Back)
		cn(b.Activated, function() box.Text = v; play(v) end)
	end
	histBox.Visible = true
end

function play(raw)
	local id = tostring(raw or ""):match("%d+")
	if not id then setStatus(T("Введите числовой ID"), C.bad) return end
	touched, trackOK, endedF = true, false, false
	playTok += 1
	local my = playTok
	sound:Stop()
	sound.SoundId = "rbxassetid://" .. id
	applyAudio()
	sound:Play()
	nameL.Text = id
	setStatus(T("Загрузка..."))
	local t0 = os.clock()
	while my == playTok and not sound.IsLoaded and os.clock() - t0 < 8 do task.wait(.1) end
	if my ~= playTok then return end
	if sound.IsLoaded and sound.TimeLength > 0 then
		local ok, info = pcall(function() return MPS:GetProductInfo(tonumber(id)) end)
		if my ~= playTok then return end
		nameL.Text = (ok and info and info.Name) or knownTitles[id] or id
		knownTitles[id] = nameL.Text
		trackOK = true
		toast("Трек загружен", C.good)
		addHistory(id)
		if cfg.autoHide then task.delay(.12, function() if opened then setOpen(false) end end) end
	else
		sound:Stop()
		nameL.Text = T("Ошибка")
		setStatus(T("Не загрузилось: ID закрыт или неверный"), C.bad)
		toast("Не удалось загрузить ID", C.bad)
	end
end

local V = {
	hl = true,
	skel = false,
	names = true,
	dist = false,
	range = 250,
	style = 1,
	fps = false,
	box = true,
	health = true,
	tracers = false,
	teamCheck = false,
	healthText = false,
	lineWidth = 1.5,
	skelWidth = 1.5,	labelSize = 13,
	brightness = 1,
}
local esp = {}
local espAny, espWas = true, false
local function refresh()
	-- Team filtering only changes which players are eligible; it is not a draw mode by itself.
	espAny = V.hl or V.skel or V.names or V.dist or V.box or V.health or V.tracers or V.healthText
end

local function mkLine()
	return new("Frame", {AnchorPoint = Vector2.new(.5, .5), BackgroundColor3 = accent, Visible = false}, skelLayer)
end
local function mkTag()
	local tag = new("TextLabel", {AnchorPoint = Vector2.new(.5, 1), Size = UDim2.fromOffset(180, 34), BackgroundTransparency = 1, Text = "",
		Font = Enum.Font.GothamBold, TextSize = V.labelSize, TextColor3 = WHITE, TextStrokeTransparency = .25, TextStrokeColor3 = Color3.new(0, 0, 0),
		TextYAlignment = Enum.TextYAlignment.Bottom, TextXAlignment = Enum.TextXAlignment.Center, Visible = false, RichText = false}, skelLayer)
	return tag
end

local function mkBoxLine()
	local line = new("Frame", {AnchorPoint = Vector2.new(.5, .5), BackgroundColor3 = accent, BackgroundTransparency = 0, Visible = false, ZIndex = 2}, skelLayer)
	return line
end

local function mkHealthBack()
	local back = new("Frame", {BackgroundColor3 = Color3.fromRGB(15, 15, 20), BackgroundTransparency = .1, Visible = false, ZIndex = 2}, skelLayer)
	stroke(back, 1, Color3.new(0, 0, 0), .2)
	return back
end

local function mkTracer()
	return new("Frame", {AnchorPoint = Vector2.new(.5, .5), BackgroundColor3 = accent, BackgroundTransparency = .1, Visible = false, ZIndex = 1}, skelLayer)
end

local function hideESPExtras(e)
	for _, line in ipairs(e.boxLines or {}) do line.Visible = false end
	if e.healthBack then e.healthBack.Visible = false end
	if e.healthFill then e.healthFill.Visible = false end
	if e.tracer then e.tracer.Visible = false end
	if e.tag then e.tag.Visible = false end
	for _, line in ipairs(e.lines or {}) do line.Visible = false end
	if e.hl then e.hl.Enabled = false end
end

local function setLine(line, x1, y1, x2, y2, thickness, color)
	local dx = x2 - x1
	local dy = y2 - y1
	local length = math.sqrt(dx * dx + dy * dy)
	line.Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2)
	line.Size = UDim2.fromOffset(length, thickness)
	line.Rotation = math.deg(math.atan2(dy, dx))
	line.BackgroundColor3 = color or accent
end

local function colorForHealth(value)
	local h = math.clamp(value, 0, 1)
	return Color3.fromRGB(255, 70, 85):Lerp(Color3.fromRGB(70, 235, 145), h)
end

local function getScreenBounds(char, cam)
	local ok, cf, size = pcall(function()
		local cf0, size0 = char:GetBoundingBox()
		return cf0, size0
	end)
	if not ok or not cf or not size then return nil end
	local hx, hy, hz = size.X / 2, size.Y / 2, size.Z / 2
	local points = {
		Vector3.new(-hx, -hy, -hz), Vector3.new(-hx, -hy, hz),
		Vector3.new(-hx, hy, -hz), Vector3.new(-hx, hy, hz),
		Vector3.new(hx, -hy, -hz), Vector3.new(hx, -hy, hz),
		Vector3.new(hx, hy, -hz), Vector3.new(hx, hy, hz),
	}
	local minX, minY = math.huge, math.huge
	local maxX, maxY = -math.huge, -math.huge
	local visibleCount = 0
	for _, localPoint in ipairs(points) do
		local worldPoint = cf:PointToWorldSpace(localPoint)
		local p2, onScreen = cam:WorldToViewportPoint(worldPoint)
		if p2.Z > 0 then
			visibleCount += 1
			minX = math.min(minX, p2.X)
			minY = math.min(minY, p2.Y)
			maxX = math.max(maxX, p2.X)
			maxY = math.max(maxY, p2.Y)
		end
	end
	if visibleCount < 2 or maxX < 0 or maxY < 0 or minX > cam.ViewportSize.X or minY > cam.ViewportSize.Y then return nil end
	minX = math.clamp(minX, 0, cam.ViewportSize.X)
	maxX = math.clamp(maxX, 0, cam.ViewportSize.X)
	minY = math.clamp(minY, 0, cam.ViewportSize.Y)
	maxY = math.clamp(maxY, 0, cam.ViewportSize.Y)
	if maxX - minX < 2 or maxY - minY < 3 then return nil end
	return minX, minY, maxX, maxY
end

local function updateBoxESP(e, char, hum, hrp, cam, vs, distance)
	local x1, y1, x2, y2 = getScreenBounds(char, cam)
	local canDraw = x1 ~= nil
	if not canDraw then
		for _, line in ipairs(e.boxLines) do line.Visible = false end
		e.healthBack.Visible = false
		e.healthFill.Visible = false
		e.tracer.Visible = false
		return false
	end
	local w = x2 - x1
	local h = y2 - y1
	local col = accent:Lerp(WHITE, (1 - math.clamp(V.brightness, .25, 1)) * .15)
	local thick = math.clamp(V.lineWidth, 1, 4)
	local edgeSpecs = {
		{x1, y1, x2, y1},
		{x2, y1, x2, y2},
		{x2, y2, x1, y2},
		{x1, y2, x1, y1},
	}
	for i, spec in ipairs(edgeSpecs) do
		local line = e.boxLines[i]
		line.Visible = V.box
		line.BackgroundTransparency = 0
		setLine(line, spec[1], spec[2], spec[3], spec[4], thick, col)
	end
	local hp = hum and hum.MaxHealth > 0 and math.clamp(hum.Health / hum.MaxHealth, 0, 1) or 0
	e.healthBack.Visible = V.health
	e.healthFill.Visible = V.health
	if V.health then
		e.healthBack.Position = UDim2.fromOffset(math.max(1, x1 - 6), y1)
		e.healthBack.Size = UDim2.fromOffset(3, h)
		e.healthFill.AnchorPoint = Vector2.new(0, 1)
		e.healthFill.Position = UDim2.fromOffset(math.max(1, x1 - 5), y2)
		e.healthFill.Size = UDim2.fromOffset(3, math.max(1, h * hp))
		e.healthFill.BackgroundColor3 = colorForHealth(hp)
		e.healthFill.Visible = V.health
	end
	e.tracer.Visible = V.tracers
	if V.tracers then
		local sx, sy = vs.X / 2, vs.Y - 2
		local tx, ty = (x1 + x2) / 2, y2
		setLine(e.tracer, sx, sy, tx, ty, math.clamp(thick, 1, 2.5), col)
	end
	return true, x1, y1, x2, y2, hp
end

local function buildBones(e, char)
	-- Named part links are more robust than enumerating Motor6D/AnimationConstraint:
	-- custom rigs often have different joint sets, and joints can be rebuilt during respawn.
	local r15 = char:FindFirstChild("UpperTorso") ~= nil
	if r15 then
		e.bones = {
			{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
			{"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
			{"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
			{"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
			{"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
		}
	else
		e.bones = {
			{"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
			{"Torso", "Left Leg"}, {"Torso", "Right Leg"},
		}
	end
	while #e.lines < #e.bones do e.lines[#e.lines + 1] = mkLine() end
end

local function drawSkel(e, cam, vs, char)
	e.lv = true
	for k, line in ipairs(e.lines) do
		local link = e.bones[k]
		local visible = false
		if link and char and char.Parent then
			local aPart = char:FindFirstChild(link[1])
			local bPart = char:FindFirstChild(link[2])
			if aPart and bPart and aPart:IsA("BasePart") and bPart:IsA("BasePart") then
				local pa = cam:WorldToViewportPoint(aPart.Position)
				local pb = cam:WorldToViewportPoint(bPart.Position)
				if pa.Z > .05 and pb.Z > .05 then
					local dx, dy = pb.X - pa.X, pb.Y - pa.Y
					local len = math.sqrt(dx * dx + dy * dy)
					if len > .5 and len < math.max(vs.X, vs.Y) * 1.5 then
						line.Position = UDim2.fromOffset((pa.X + pb.X) / 2, (pa.Y + pb.Y) / 2)
						line.Size = UDim2.fromOffset(len, math.clamp(V.skelWidth or 1.5, 1, 4))
						line.Rotation = math.deg(math.atan2(dy, dx))
						line.BackgroundColor3 = accent:Lerp(WHITE, (1 - math.clamp(V.brightness, .25, 1)) * .15)
						line.BackgroundTransparency = 0
						visible = true
					end
				end
			end
		end
		line.Visible = visible
	end
end

local function updateESP(t)
	local cam = workspace.CurrentCamera
	if not cam then return end
	local vs = cam.ViewportSize
	local myc = lp.Character
	local mh = myc and myc:FindFirstChild("HumanoidRootPart")
	local origin = mh and mh.Position or cam.CFrame.Position
	for plr, e in pairs(esp) do
		local char = plr.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local d = hrp and (hrp.Position - origin).Magnitude or math.huge
		local sameTeam = V.teamCheck and lp.Team ~= nil and plr.Team ~= nil and lp.Team == plr.Team
		local alive = hrp ~= nil and hum ~= nil and hum.Health > 0 and d <= V.range and not sameTeam
		local hl = e.hl
		if e.char ~= char then
			e.char = char
			hl.Adornee = char
			hl.Parent = workspace
			e.bchar = nil
		end
		local showHl = V.hl and alive
		hl.Enabled = showHl
		if showHl then
			if V.style == 1 then
				hl.FillColor = accent
				hl.OutlineColor = accent
				hl.FillTransparency = 1
				hl.OutlineTransparency = 0
			elseif V.style == 2 then
				hl.FillColor = accent
				hl.OutlineColor = WHITE
				hl.FillTransparency = .45
				hl.OutlineTransparency = .2
			else
				local k = (math.sin(t * 2.4 + e.ph) + 1) / 2
				hl.FillColor = accent:Lerp(shift(accent), k)
				hl.OutlineColor = shift(accent):Lerp(accent, k)
				hl.FillTransparency = .5
				hl.OutlineTransparency = .1
			end
		end
		local boxOK, x1, y1, x2, y2, hp
		if alive and (V.box or V.health or V.tracers) then
			boxOK, x1, y1, x2, y2, hp = updateBoxESP(e, char, hum, hrp, cam, vs, d)
		else
			for _, line in ipairs(e.boxLines) do line.Visible = false end
			e.healthBack.Visible = false
			e.healthFill.Visible = false
			e.tracer.Visible = false
		end
		local sk = V.skel and alive
		if sk and e.bchar ~= char then
			e.bchar, e.bt = char, t
			buildBones(e, char)
		end
		if sk then
			drawSkel(e, cam, vs, char)
		else
			for _, l in ipairs(e.lines) do l.Visible = false end
			e.lv = false
		end
		local tag = e.tag
		if alive and (V.names or V.dist or V.healthText) then
			local head = char:FindFirstChild("Head") or hrp
			local pt = cam:WorldToViewportPoint(head.Position + Vector3.new(0, head.Size.Y / 2 + .6, 0))
			if pt.Z > 0 and pt.X >= -80 and pt.X <= vs.X + 80 and pt.Y >= -50 and pt.Y <= vs.Y + 30 then
				local label = V.names and plr.DisplayName or ""
				if V.dist then label = (label ~= "" and label .. "\n" or "") .. string.format("%d %s", math.floor(d), T("ст.")) end
				if V.healthText and hum then label = (label ~= "" and label .. "\n" or "") .. string.format("%d%% HP", math.floor(math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1) * 100)) end
					tag.Text = label
				tag.TextSize = V.labelSize
				tag.Position = UDim2.fromOffset(pt.X, pt.Y)
				tag.Visible = label ~= ""
			else
				tag.Visible = false
			end
		else
			tag.Visible = false
		end
		if not alive then hideESPExtras(e) end
	end
end

local function attach(plr)
	if plr == lp or esp[plr] then return end
	local hl = new("Highlight", {Name = "AuraHL", DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Enabled = false,
		FillTransparency = 1, OutlineTransparency = 1}, workspace)
	local e = {
		hl = hl,
		tag = mkTag(),
		lines = {},
		bones = {},
		bt = 0,
		ph = math.random() * 6,
		lv = false,
		boxLines = {},
		healthBack = mkHealthBack(),
		healthFill = new("Frame", {BackgroundColor3 = C.good, Visible = false, ZIndex = 3}, skelLayer),
		tracer = mkTracer(),
	}
	for _ = 1, 4 do e.boxLines[#e.boxLines + 1] = mkBoxLine() end
	esp[plr] = e
end

local function detach(plr)
	local e = esp[plr]
	if not e then return end
	e.hl:Destroy()
	e.tag:Destroy()
	for _, l in ipairs(e.lines) do l:Destroy() end
	for _, l in ipairs(e.boxLines) do l:Destroy() end
	e.healthBack:Destroy()
	e.healthFill:Destroy()
	e.tracer:Destroy()
	esp[plr] = nil
end
for _, p in ipairs(Players:GetPlayers()) do attach(p) end
cn(Players.PlayerAdded, attach)
cn(Players.PlayerRemoving, detach)

local afkOn, rejoinOn, rejoining = true, false, false
local fovT, fovOn = 70, false
cn(lp.Idled, function()
	if afkOn and okVU and VU then
		pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
	end
end)
local function rejoin()
	if not rejoinOn or rejoining then return end
	rejoining = true
	toast("Переподключение...")
	task.wait(1)
	local ok = pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp) end)
	if not ok then pcall(function() TeleportService:Teleport(game.PlaceId, lp) end) end
	task.delay(8, function() rejoining = false end)
end
cn(GuiService.ErrorMessageChanged, function()
	local ok, m = pcall(function() return GuiService:GetErrorMessage() end)
	if rejoinOn and (not ok or m ~= "") then task.spawn(rejoin) end
end)
cn(TeleportService.TeleportInitFailed, function()
	if rejoinOn then task.delay(2, function() pcall(function() TeleportService:Teleport(game.PlaceId, lp) end) end) end
end)

local fpsF = new("Frame", {Size = UDim2.fromOffset(112, 26), Position = UDim2.new(1, -122, 0, 10), BackgroundColor3 = C.bar, Visible = false, ZIndex = 15}, gui)
round(fpsF, 13); stroke(fpsF, 1, WHITE, .85)
local fpsS = new("UIScale", {Scale = .01}, fpsF)
local fpsD = new("Frame", {AnchorPoint = Vector2.new(0, .5), Position = UDim2.new(0, 10, .5, 0), Size = UDim2.fromOffset(8, 8), BackgroundColor3 = C.good, ZIndex = 16}, fpsF)
round(fpsD, 4)
local fpsL = new("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(24, 0), Size = UDim2.new(1, -28, 1, 0), Font = Enum.Font.GothamBold,
	TextSize = 12, TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left, Text = "", ZIndex = 16}, fpsF)
drag(fpsF, fpsF, function(W, H) return 0, W - 112, 0, H - 26 end)
local function showFps(v)
	if v then
		fpsF.Visible = true
		tw(fpsS, {Scale = 1}, .45, EASE.Back)
	else
		tw(fpsS, {Scale = .01}, .25, EASE.Quad, DIR.In)
		task.delay(.27, function() if not V.fps then fpsF.Visible = false end end)
	end
end
local fpsA, fpsN = 0, 0

local function unload()
	pcall(function() RS:UnbindFromRenderStep("AuraMenuLoop") end)
	if __AuraFix_activeTweens then for _, records in pairs(__AuraFix_activeTweens) do for _, record in ipairs(records) do pcall(function() record.tween:Cancel() end) end end; table.clear(__AuraFix_activeTweens) end
	for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	for plr in pairs(esp) do detach(plr) end
	for _, object in ipairs({blur, sound, gui, __AuraFix_envBloom, __AuraFix_envColor, __AuraFix_envRays}) do
		if object and object.Parent then pcall(function() object:Destroy() end) end
	end
	genv.AuraUnload = nil
end
genv.AuraUnload = unload

local spd, tapeT, semi, vol, bassS, midS, trebS, reverbT, echoT, prog, pauseB
local function resetAll()
	spd.Set(1); tapeT.Set(true); semi.Set(0); vol.Set(0)
	bassS.Set(0); midS.Set(0); trebS.Set(0); reverbT.Set(false); echoT.Set(false)
end
local function dbfmt(v) return string.format("%+.0f dB", v) end

__AuraFix_pg = page("Музыка")
section(__AuraFix_pg, "ПЛЕЕР")
__AuraFix_idc = card(__AuraFix_pg, 42)
box = new("TextBox", {Text = "", ClearTextOnFocus = false, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.text,
	PlaceholderColor3 = C.sub, BackgroundColor3 = C.card2, TextXAlignment = Enum.TextXAlignment.Left, ClipsDescendants = true,
	Position = UDim2.fromOffset(6, 6), Size = UDim2.new(1, -94, 1, -12)}, __AuraFix_idc)
bind(box, "Вставьте ID песни", "PlaceholderText")
round(box, 6); new("UIPadding", {PaddingLeft = UDim.new(0, 8)}, box)
__AuraFix_bs = stroke(box, 1.5, accent, 1); acc(__AuraFix_bs, "Color")
cn(box.Focused, function() tw(__AuraFix_bs, {Transparency = 0}, .2) end)
cn(box.FocusLost, function(enter)
	tw(__AuraFix_bs, {Transparency = 1}, .25)
	box.Text = box.Text:match("%d+") or ""
	if enter then play(box.Text) end
end)
cn(box:GetPropertyChangedSignal("Text"), function()
	local s = box.Text:match("%d+") or ""
	if s ~= box.Text then box.Text = s end
end)
__AuraFix_go = button(__AuraFix_idc, "Играть", function() play(box.Text) end, true, UDim2.new(0, 76, 1, -12))
__AuraFix_go.Position = UDim2.new(1, -82, 0, 6)

__AuraFix_np = card(__AuraFix_pg, 60)
__AuraFix_vinyl = new("Frame", {AnchorPoint = Vector2.new(0, .5), Position = UDim2.new(0, 10, .5, 0), Size = UDim2.fromOffset(44, 44),
	BackgroundColor3 = WHITE}, __AuraFix_np)
round(__AuraFix_vinyl, 22)
__AuraFix_vs = stroke(__AuraFix_vinyl, 2, accent, .4); acc(__AuraFix_vs, "Color")
__AuraFix_hi, __AuraFix_lo2 = Color3.fromRGB(95, 95, 118), Color3.fromRGB(22, 22, 30)
new("UIGradient", {Rotation = 35, Color = ColorSequence.new({ColorSequenceKeypoint.new(0, __AuraFix_hi), ColorSequenceKeypoint.new(.25, __AuraFix_lo2),
	ColorSequenceKeypoint.new(.5, __AuraFix_hi), ColorSequenceKeypoint.new(.75, __AuraFix_lo2), ColorSequenceKeypoint.new(1, __AuraFix_hi)})}, __AuraFix_vinyl)
for _, d in ipairs({36, 28}) do
	local g = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Size = UDim2.fromOffset(d, d), BackgroundTransparency = 1}, __AuraFix_vinyl)
	round(g, d / 2); stroke(g, 1, WHITE, .88)
end
__AuraFix_vlab = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Size = UDim2.fromOffset(16, 16)}, __AuraFix_vinyl)
round(__AuraFix_vlab, 8); acc(__AuraFix_vlab, "BackgroundColor3")
__AuraFix_vhole = new("Frame", {AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Size = UDim2.fromOffset(4, 4), BackgroundColor3 = C.card}, __AuraFix_vlab)
round(__AuraFix_vhole, 2)
nameL = lbl(__AuraFix_np, "", 13, nil, {Position = UDim2.fromOffset(64, 10), Size = UDim2.new(1, -74, 0, 18), Font = Enum.Font.GothamBold})
statusL = lbl(__AuraFix_np, "", 11, C.sub, {Position = UDim2.fromOffset(64, 30), Size = UDim2.new(1, -74, 0, 16)})
trReg[#trReg + 1] = idle
idle()

histBox = new("Frame", {Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Visible = false}, __AuraFix_pg)
new("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5)}, histBox)

section(__AuraFix_pg, "ПОИСК ПО НАЗВАНИЮ")
__AuraFix_searchCard = card(__AuraFix_pg, 42)
searchBox = new("TextBox", {
	Text = "",
	ClearTextOnFocus = false,
	Font = Enum.Font.GothamMedium,
	TextSize = 13,
	TextColor3 = C.text,
	PlaceholderColor3 = C.sub,
	PlaceholderText = T("Название песни"),
	BackgroundColor3 = C.card2,
	TextXAlignment = Enum.TextXAlignment.Left,
	ClipsDescendants = true,
	Position = UDim2.fromOffset(6, 6),
	Size = UDim2.new(1, -94, 1, -12),
}, __AuraFix_searchCard)
round(searchBox, 7)
new("UIPadding", {PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 5)}, searchBox)
__AuraFix_searchStroke = stroke(searchBox, 1.5, accent, 1)
acc(__AuraFix_searchStroke, "Color")
cn(searchBox.Focused, function() tw(__AuraFix_searchStroke, {Transparency = .1}, .2) end)
cn(searchBox.FocusLost, function(enter)
	tw(__AuraFix_searchStroke, {Transparency = 1}, .25)
	if enter then
		local btn = __AuraFix_searchCard:FindFirstChild("SearchButton")
		if btn then btn:Activate() end
	end
end)
__AuraFix_searchButton = button(__AuraFix_searchCard, "Найти", nil, true, UDim2.new(0, 76, 1, -12))
__AuraFix_searchButton.Name = "SearchButton"
__AuraFix_searchButton.Position = UDim2.new(1, -82, 0, 6)

__AuraFix_searchInfoCard = new("Frame", {Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = C.card3, BackgroundTransparency = .1}, __AuraFix_pg)
round(__AuraFix_searchInfoCard, 7)
__AuraFix_searchInfoDot = new("Frame", {Position = UDim2.fromOffset(10, 10), Size = UDim2.fromOffset(8, 8), BackgroundColor3 = accent}, __AuraFix_searchInfoCard)
round(__AuraFix_searchInfoDot, 4)
__AuraFix_searchStatusL = lbl(__AuraFix_searchInfoCard, "Поиск выполняется через AssetService", 11, C.sub, {Position = UDim2.fromOffset(25, 0), Size = UDim2.new(1, -32, 1, 0)})
searchStatus = __AuraFix_searchStatusL

searchResults = new("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1}, __AuraFix_pg)
new("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, searchResults)

__AuraFix_queueHeading = section(__AuraFix_pg, "ОЧЕРЕДЬ")
__AuraFix_queueInfo = card(__AuraFix_pg, 30)
queueStatus = lbl(__AuraFix_queueInfo, "Очередь пуста", 11, C.sub, {Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -96, 1, 0)})
__AuraFix_clearQueueButton = button(__AuraFix_queueInfo, "Очистить очередь", function()
	table.clear(queueItems)
	if queueList then
		for _, child in ipairs(queueList:GetChildren()) do
			if not child:IsA("UIListLayout") then child:Destroy() end
		end
	end
	queueStatus.Text = T("Очередь пуста")
	toast("Список очищен")
end, false, UDim2.new(0, 90, 1, -8))
__AuraFix_clearQueueButton.Position = UDim2.new(1, -94, 0, 4)
queueList = new("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1}, __AuraFix_pg)
new("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, queueList)

function __AuraFix_clearGenerated(parent)
	for _, child in ipairs(parent:GetChildren()) do
		if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then child:Destroy() end
	end
end

function __AuraFix_renderQueue()
	if not queueList then return end
	__AuraFix_clearGenerated(queueList)
	local count = #queueItems
	queueStatus.Text = count > 0 and (T("В очереди") .. ": " .. tostring(count)) or T("Очередь пуста")
	if count == 0 then
		local empty = new("Frame", {Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = C.card3, BackgroundTransparency = .2}, queueList)
		round(empty, 7)
		lbl(empty, T("Очередь пуста"), 11, C.sub, {Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -20, 1, 0)})
		return
	end
	for index, item in ipairs(queueItems) do
		local rowFrame = new("Frame", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = C.card, BackgroundTransparency = .05}, queueList)
		round(rowFrame, 7)
		local countLabel = new("TextLabel", {BackgroundColor3 = C.card2, Position = UDim2.fromOffset(5, 5), Size = UDim2.fromOffset(26, 26), Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = accent, Text = string.format("%02d", index)}, rowFrame)
		round(countLabel, 6)
		local titleLabel = lbl(rowFrame, item.title or item.id, 11, C.text, {Position = UDim2.fromOffset(38, 1), Size = UDim2.new(1, -116, 1, -2), Font = Enum.Font.GothamMedium})
		local playNow = new("TextButton", {Text = "▶", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = WHITE, AutoButtonColor = false, BackgroundColor3 = accent, AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -40, .5, 0), Size = UDim2.fromOffset(30, 26)}, rowFrame)
		round(playNow, 6)
		press(playNow, true)
		cn(playNow.Activated, function()
			table.remove(queueItems, index)
			__AuraFix_renderQueue()
			box.Text = item.id
			play(item.id)
		end)
		local remove = new("TextButton", {Text = "×", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = C.sub, AutoButtonColor = false, BackgroundColor3 = C.card2, AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -6, .5, 0), Size = UDim2.fromOffset(28, 26)}, rowFrame)
		round(remove, 6)
		press(remove, true)
		cn(remove.Activated, function()
			table.remove(queueItems, index)
			__AuraFix_renderQueue()
		end)
		cn(rowFrame.MouseEnter, function() tw(rowFrame, {BackgroundColor3 = C.card2}, .15) end)
		cn(rowFrame.MouseLeave, function() tw(rowFrame, {BackgroundColor3 = C.card}, .2) end)
	end
end

function __AuraFix_addToQueue(id, title, artist)
	id = tostring(id or "")
	if not id:match("^%d+$") then return end
	for _, item in ipairs(queueItems) do
		if item.id == id then
			toast("Уже в очереди", C.warn)
			return
		end
	end
	table.insert(queueItems, {id = id, title = title or knownTitles[id] or id, artist = artist})
	__AuraFix_renderQueue()
	toast("Добавлено в очередь", C.good)
end

function __AuraFix_clearSearchResults()
	__AuraFix_clearGenerated(searchResults)
	searchResultCount = 0
end

function __AuraFix_addSearchResult(audio)
	local id = tostring(audio.Id or audio.AssetId or audio.id or "")
	local title = tostring(audio.Title or audio.Name or ("Audio " .. id))
	local creator = audio.Artist
	if type(creator) ~= "string" or creator == "" then
		creator = type(audio.Creator) == "table" and tostring(audio.Creator.Name or "") or ""
	end
	if creator == "" then creator = T("Автор неизвестен") end
	if id == "" or not id:match("^%d+$") then return end
	knownTitles[id] = title
	local result = new("Frame", {Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = C.card, BackgroundTransparency = .02}, searchResults)
	round(result, 8)
	local edge = stroke(result, 1, accent, .88)
	local leftGlow = new("Frame", {Size = UDim2.new(0, 3, 1, -12), Position = UDim2.fromOffset(5, 6), BackgroundColor3 = accent}, result)
	round(leftGlow, 2)
	local titleText = lbl(result, title, 12, C.text, {Position = UDim2.fromOffset(15, 4), Size = UDim2.new(1, -116, 0, 19), Font = Enum.Font.GothamBold})
	local detail = lbl(result, creator .. " · " .. id, 10, C.sub, {Position = UDim2.fromOffset(15, 24), Size = UDim2.new(1, -116, 0, 16)})
	local playResult = new("TextButton", {Text = "▶", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = WHITE, AutoButtonColor = false, BackgroundColor3 = accent, AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -52, .5, 0), Size = UDim2.fromOffset(36, 30)}, result)
	round(playResult, 7)
	press(playResult, true)
	local queueResult = new("TextButton", {Text = "+", Font = Enum.Font.GothamBold, TextSize = 19, TextColor3 = C.text, AutoButtonColor = false, BackgroundColor3 = C.card2, AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -8, .5, 0), Size = UDim2.fromOffset(36, 30)}, result)
	round(queueResult, 7)
	press(queueResult, true)
	cn(playResult.Activated, function()
		box.Text = id
		play(id)
	end)
	cn(queueResult.Activated, function() __AuraFix_addToQueue(id, title, creator) end)
	cn(result.MouseEnter, function()
		tw(result, {BackgroundColor3 = C.card2}, .16)
		tw(edge, {Transparency = .55}, .16)
		tw(leftGlow, {Size = UDim2.new(0, 4, 1, -8)}, .16)
	end)
	cn(result.MouseLeave, function()
		tw(result, {BackgroundColor3 = C.card}, .2)
		tw(edge, {Transparency = .88}, .2)
		tw(leftGlow, {Size = UDim2.new(0, 3, 1, -12)}, .2)
	end)
	searchResultCount += 1
end

function __AuraFix_searchAudio(query)
	query = tostring(query or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if #query < 2 then
		searchStatus.Text = T("Введите хотя бы 2 символа")
		__AuraFix_searchInfoDot.BackgroundColor3 = C.warn
		return
	end
	searchToken += 1
	local requestId = searchToken
	currentSearchTerm = query
	__AuraFix_clearSearchResults()
	searchStatus.Text = T("Поиск...")
	__AuraFix_searchInfoDot.BackgroundColor3 = accent
	tw(__AuraFix_searchInfoDot, {BackgroundTransparency = .45}, .18)
	task.spawn(function()
		local ok, pages = pcall(function()
			local service = game:GetService("AssetService")
			local params = Instance.new("AudioSearchParams")
			local paramsOK, results = pcall(function()
				params.SearchKeyword = query
				params.MaxPageSize = 20
				return service:SearchAudioAsync(params)
			end)
			params:Destroy()
			if not paramsOK then error(results) end
			return results
		end)
		if requestId ~= searchToken then return end
		if not ok or not pages then
			searchStatus.Text = T("Поиск недоступен в этой среде")
			__AuraFix_searchInfoDot.BackgroundColor3 = C.bad
			-- Show a single actionable status instead of duplicating the error as a result card.
			return
		end
		local pageOK, pageData = pcall(function() return pages:GetCurrentPage() end)
		if requestId ~= searchToken then return end
		if not pageOK or type(pageData) ~= "table" then
			searchStatus.Text = T("Поиск недоступен в этой среде")
			__AuraFix_searchInfoDot.BackgroundColor3 = C.bad
			return
		end
		local added = 0
		for _, audio in ipairs(pageData) do
			if added >= 15 then break end
			if type(audio) == "table" then
				local before = searchResultCount
				__AuraFix_addSearchResult(audio)
				if searchResultCount > before then added += 1 end
			end
		end
		if added == 0 then
			searchStatus.Text = T("Ничего не найдено")
			__AuraFix_searchInfoDot.BackgroundColor3 = C.warn
			local noResult = new("Frame", {Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = C.card, BackgroundTransparency = .05}, searchResults)
			round(noResult, 8)
			lbl(noResult, T("Ничего не найдено"), 11, C.sub, {Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -20, 1, 0)})
		else
			searchStatus.Text = T("Список результатов") .. ": " .. tostring(added) .. " · " .. query
			__AuraFix_searchInfoDot.BackgroundColor3 = C.good
		end
	end)
end

cn(__AuraFix_searchButton.Activated, function() __AuraFix_searchAudio(searchBox.Text) end)
cn(searchBox:GetPropertyChangedSignal("Text"), function()
	if #searchBox.Text > 90 then searchBox.Text = searchBox.Text:sub(1, 90) end
end)
__AuraFix_renderQueue()

-- Compact, top-centred music bar inspired by the layout shown in the user's DDNet video.
-- It remains visible when the full settings window is closed and is sized for phone screens.
local miniPlayer = new("Frame", {
	Name = "AuraMiniPlayer",
	AnchorPoint = Vector2.new(.5, 0),
	Position = UDim2.new(.5, 0, 0, (GuiService:GetGuiInset().Y or 0) + 8),
	Size = UDim2.new(1, -20, 0, 42),
	BackgroundColor3 = C.bar,
	BackgroundTransparency = .04,
	ZIndex = 40,
}, gui)
miniPlayer.Size = UDim2.new(0, math.clamp(vp.X - 20, 250, 360), 0, 42)
round(miniPlayer, 12)
local miniPlayerStroke = stroke(miniPlayer, 1.3, accent, .25)
acc(miniPlayerStroke, "Color")
local miniPlayerDot = new("Frame", {
	Position = UDim2.fromOffset(10, 17), Size = UDim2.fromOffset(8, 8),
	BackgroundColor3 = C.sub, ZIndex = 41,
}, miniPlayer)
round(miniPlayerDot, 4)
local miniPlayerTitle = new("TextLabel", {
	Name = "TrackTitle",
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(25, 3),
	Size = UDim2.new(1, -125, 1, -6),
	Font = Enum.Font.GothamSemibold,
	Text = T("Ничего не играет"),
	TextColor3 = C.text,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTruncate = Enum.TextTruncate.AtEnd,
	ZIndex = 41,
}, miniPlayer)
local miniPlayerPlay = new("TextButton", {
	Name = "PlayPause",
	Text = "▶",
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	TextColor3 = WHITE,
	BackgroundColor3 = accent,
	AutoButtonColor = false,
	Position = UDim2.new(1, -91, 0, 6),
	Size = UDim2.fromOffset(32, 30),
	ZIndex = 41,
}, miniPlayer)
round(miniPlayerPlay, 8)
press(miniPlayerPlay, true)
local miniPlayerOpen = new("TextButton", {
	Name = "OpenMenu",
	Text = "☰",
	Font = Enum.Font.GothamBold,
	TextSize = 15,
	TextColor3 = C.text,
	BackgroundColor3 = C.card2,
	AutoButtonColor = false,
	Position = UDim2.new(1, -52, 0, 6),
	Size = UDim2.fromOffset(32, 30),
	ZIndex = 41,
}, miniPlayer)
round(miniPlayerOpen, 8)
press(miniPlayerOpen, true)
cn(miniPlayerPlay.Activated, function()
	if sound.IsPlaying then
		sound:Pause()
	elseif sound.IsPaused then
		sound:Resume()
	elseif sound.SoundId ~= "" then
		endedF = false
		sound:Play()
	else
		setOpen(true)
		__AuraFix_selectTab("Музыка")
	end
end)
cn(miniPlayerOpen.Activated, function()
	setOpen(true)
	__AuraFix_selectTab("Музыка")
end)
local function updateMiniPlayerPosition()
	local camera = workspace.CurrentCamera
	local size = camera and camera.ViewportSize or Vector2.new(360, 640)
	miniPlayer.Size = UDim2.new(0, math.clamp(size.X - 20, 250, 360), 0, 42)
	miniPlayer.Position = UDim2.new(.5, 0, 0, (GuiService:GetGuiInset().Y or 0) + 8)
end

local function rescaleMainForViewport()
	local camera = workspace.CurrentCamera
	local size = camera and camera.ViewportSize or Vector2.new(800, 400)
	local fit = math.clamp(math.min((size.Y - 40) / WIN_H, (size.X - 16) / WIN_W), .52, 1)
	local requested = math.clamp((tonumber(cfg.size) or (baseScale * 100)) / 100, .52, 1.3)
	baseScale = math.min(requested, fit)
	startPos = UDim2.new(.5, 0, 0, math.max(6, (size.Y - WIN_H * baseScale) / 2))
	if holder and holder.Parent then
		local maxY = math.max(6, size.Y - WIN_H * baseScale)
		local currentY = holder.Position.Y.Scale * size.Y + holder.Position.Y.Offset
		holder.Position = UDim2.new(.5, 0, 0, math.clamp(currentY, 6, maxY))
		if mscale and mscale.Parent then tw(mscale, {Scale = baseScale}, .32, EASE.Quint) end
	end
end
if workspace.CurrentCamera then
	cn(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), updateMiniPlayerPosition)
	cn(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), rescaleMainForViewport)
end
cn(workspace:GetPropertyChangedSignal("CurrentCamera"), function()
	local camera = workspace.CurrentCamera
	if camera then
		cn(camera:GetPropertyChangedSignal("ViewportSize"), updateMiniPlayerPosition)
		cn(camera:GetPropertyChangedSignal("ViewportSize"), rescaleMainForViewport)
		updateMiniPlayerPosition()
		rescaleMainForViewport()
	end
end)

__AuraFix_vc = card(__AuraFix_pg, 56)
__AuraFix_bars = {}
for n = 1, 28 do
	local b = new("Frame", {BackgroundColor3 = WHITE, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new((n - 1) / 28, 2, 1, -6), Size = UDim2.new(1 / 28, -3, 0, 3)}, __AuraFix_vc)
	round(b, 2)
	grad(b, function() return ColorSequence.new(light(accent):Lerp(accent, .4), accent) end, {Rotation = 90})
	local cap = new("Frame", {AnchorPoint = Vector2.new(0, 1), Position = UDim2.new((n - 1) / 28, 2, 1, -11), Size = UDim2.new(1 / 28, -3, 0, 2)}, __AuraFix_vc)
	round(cap, 1); acc(cap, "BackgroundColor3")
	__AuraFix_bars[n] = {f = b, c = cap, h = 0, p = 0}
end
prog = slider(__AuraFix_pg, "Трек", 0, 1, 0, function(v)
	local l = sound.TimeLength
	return fmtT(v * l) .. " / " .. fmtT(l)
end, function(v)
	if sound.TimeLength > 0 then sound.TimePosition = v * sound.TimeLength end
end, nil, nil, true)
__AuraFix_r = row(__AuraFix_pg, 32)
__AuraFix_q = UDim2.new(.25, -5, 1, 0)
button(__AuraFix_r, "-10с", function() sound.TimePosition = math.max(0, sound.TimePosition - 10) end, false, __AuraFix_q)
pauseB = button(__AuraFix_r, "Пауза", function()
	if sound.IsPlaying then sound:Pause()
	elseif sound.IsPaused then sound:Resume()
	elseif sound.SoundId ~= "" then endedF = false; sound:Play() end
end, true, __AuraFix_q)
button(__AuraFix_r, "Стоп", function()
	playTok += 1
	sound:Stop()
	if not trackOK and touched then setStatus(T("Остановлено")) end
end, false, __AuraFix_q)
button(__AuraFix_r, "+10с", function() sound.TimePosition = math.min(sound.TimeLength, sound.TimePosition + 10) end, false, __AuraFix_q)
toggle(__AuraFix_pg, "Повтор трека", false, function(v) sound.Looped = v end, "loop")

section(__AuraFix_pg, "СКОРОСТЬ И ТОНАЛЬНОСТЬ")
spd = slider(__AuraFix_pg, "Скорость", .25, 3, 1, function(v) return string.format("%.2fx", v) end, function(v) S.speed = v; applyAudio() end, .05, "speed")
tapeT = toggle(__AuraFix_pg, "Менять тон со скоростью", true, function(v) S.tape = v; applyAudio() end, "tape")
semi = slider(__AuraFix_pg, "Тональность", -12, 12, 0, function(v) return string.format("%+.0f %s", v, T("пт")) end, function(v) S.semi = v; applyAudio() end, 1, "semi")
section(__AuraFix_pg, "ГРОМКОСТЬ")
vol = slider(__AuraFix_pg, "Усиление", -40, 20, 0, dbfmt, function(v) S.db = v; applyAudio() end, 1, "db")
__AuraFix_volumeQuick = row(__AuraFix_pg, 30)
button(__AuraFix_volumeQuick, "Тихо", function() vol.Set(-12); toast("Тихо") end, false, __AuraFix_q)
button(__AuraFix_volumeQuick, "Обычный", function() vol.Set(0); toast("Обычный") end, false, __AuraFix_q)
button(__AuraFix_volumeQuick, "Громко", function() vol.Set(8); toast("Громко") end, false, __AuraFix_q)
button(__AuraFix_volumeQuick, "Максимум", function() vol.Set(16); toast("Максимум", C.warn) end, false, __AuraFix_q)
section(__AuraFix_pg, "БЫСТРЫЕ НАСТРОЙКИ")
__AuraFix_musicOptions = row(__AuraFix_pg, 30)
button(__AuraFix_musicOptions, "Пуск / пауза", function()
	if sound.IsPlaying then sound:Pause() elseif sound.IsPaused then sound:Resume() elseif sound.SoundId ~= "" then sound:Play() end
end, true, UDim2.new(.5, -3, 1, 0))
button(__AuraFix_musicOptions, "Очистить очередь", function()
	table.clear(queueItems)
	__AuraFix_renderQueue()
	toast("Список очищен")
end, false, UDim2.new(.5, -3, 1, 0))
section(__AuraFix_pg, "ВИЗУАЛИЗАТОР")
segment(__AuraFix_pg, "Стиль", {"Мягкий", "Пики", "Спектр"}, function(i) visualizerStyle = i end, 1, "visualizerStyle")
toggle(__AuraFix_pg, "Пульсация акцента", true, function(v) musicAccentPulse = v end, "musicAccentPulse")
toggle(__AuraFix_pg, "Авто-очередь", true, function(v) queueAutoPlay = v end, "queueAutoPlay")
button(__AuraFix_pg, "Сбросить всё", resetAll)

__AuraFix_pe = page("Эффекты")
function __AuraFix_preset(name, fn)
	return function() resetAll(); fn(); toast(T("Пресет: ") .. name) end
end
section(__AuraFix_pe, "ПРЕСЕТЫ")
__AuraFix_pr = row(__AuraFix_pe, 30)
button(__AuraFix_pr, "Ночной", __AuraFix_preset("Ночной", function() spd.Set(1.25); tapeT.Set(true) end), false, __AuraFix_q)
button(__AuraFix_pr, "Замедленный", __AuraFix_preset("Замедленный", function() spd.Set(.85); tapeT.Set(true); reverbT.Set(true) end), false, __AuraFix_q)
button(__AuraFix_pr, "Бас", __AuraFix_preset("Бас", function() bassS.Set(10); midS.Set(-3); trebS.Set(2) end), false, __AuraFix_q)
button(__AuraFix_pr, "Сброс", function() resetAll(); toast("Всё сброшено") end, false, __AuraFix_q)
section(__AuraFix_pe, "ЭКВАЛАЙЗЕР")
bassS = slider(__AuraFix_pe, "Низкие", -20, 10, 0, dbfmt, function(v) eq.LowGain = v end, 1, "bass")
midS = slider(__AuraFix_pe, "Средние", -20, 10, 0, dbfmt, function(v) eq.MidGain = v end, 1, "mid")
trebS = slider(__AuraFix_pe, "Высокие", -20, 10, 0, dbfmt, function(v) eq.HighGain = v end, 1, "treb")
section(__AuraFix_pe, "ПРОСТРАНСТВО")
reverbT = toggle(__AuraFix_pe, "Реверберация", false, function(v) reverb.Enabled = v end, "reverb")
echoT = toggle(__AuraFix_pe, "Эхо", false, function(v) echo.Enabled = v end, "echo")

-- Local post-processing only. Mood inspiration: https://github.com/Eldergenix/Roblox-Game/blob/main/.agents/skills/roblox-lighting/SKILL.md
-- These preset values and the animated Aurora mode are authored for this menu.
__AuraFix_envBloom = Instance.new("BloomEffect")
__AuraFix_envBloom.Name = "AuraEnvBloom"
__AuraFix_envBloom.Enabled = false
__AuraFix_envBloom.Intensity = 0.42
__AuraFix_envBloom.Size = 28
__AuraFix_envBloom.Threshold = 0.9
__AuraFix_envBloom.Parent = Lighting

__AuraFix_envColor = Instance.new("ColorCorrectionEffect")
__AuraFix_envColor.Name = "AuraEnvColor"
__AuraFix_envColor.Enabled = false
__AuraFix_envColor.Brightness = 0
__AuraFix_envColor.Contrast = 0
__AuraFix_envColor.Saturation = 0
__AuraFix_envColor.TintColor = WHITE
__AuraFix_envColor.Parent = Lighting

__AuraFix_envRays = Instance.new("SunRaysEffect")
__AuraFix_envRays.Name = "AuraEnvRays"
__AuraFix_envRays.Enabled = false
__AuraFix_envRays.Intensity = 0
__AuraFix_envRays.Spread = 0.75
__AuraFix_envRays.Parent = Lighting

local envPreset = math.clamp(math.floor(tonumber(cfg.envPreset) or 0), 0, 6)
local envOn = cfg.envBloom == true
local envStrength = math.clamp(tonumber(cfg.envBloomStrength) or 45, 0, 100)
local envBaseBloom, envPhase, envTick = 0.32, 0, 0
local envButtons = {}
local envPresets = {
	[0] = {name = "Мягкое свечение", bloom = .32, size = 22, threshold = 1.1,
		brightness = 0, contrast = .02, saturation = .04, tint = WHITE, rays = 0, spread = .75},
	[1] = {name = "Золотой час", bloom = .38, size = 28, threshold = .92,
		brightness = .025, contrast = .08, saturation = .2, tint = Color3.fromRGB(255, 218, 180), rays = .06, spread = .8},
	[2] = {name = "Полночь", bloom = .22, size = 22, threshold = 1.08,
		brightness = -.025, contrast = .14, saturation = -.1, tint = Color3.fromRGB(182, 201, 255), rays = .015, spread = .75},
	[3] = {name = "Ужас", bloom = .24, size = 22, threshold = 1.05,
		brightness = -.065, contrast = .2, saturation = -.24, tint = Color3.fromRGB(255, 179, 188), rays = 0, spread = .7},
	[4] = {name = "Под водой", bloom = .3, size = 26, threshold = .98,
		brightness = -.01, contrast = .06, saturation = .1, tint = Color3.fromRGB(150, 213, 255), rays = .018, spread = .85},
	[5] = {name = "Научная фантастика", bloom = .56, size = 32, threshold = .82,
		brightness = .015, contrast = .16, saturation = .24, tint = Color3.fromRGB(207, 185, 255), rays = .035, spread = .9},
	[6] = {name = "Северное сияние", bloom = .4, size = 30, threshold = .9,
		brightness = .005, contrast = .1, saturation = .18, tint = Color3.fromRGB(160, 255, 225), rays = .02, spread = .88},
}

local function applyEnvironmentPreset(index)
	index = math.clamp(math.floor(tonumber(index) or 0), 0, 6)
	envPreset = index
	cfg.envPreset = index
	local p = envPresets[index] or envPresets[0]
	envBaseBloom = p.bloom
	__AuraFix_envBloom.Size = p.size
	__AuraFix_envBloom.Threshold = p.threshold
	__AuraFix_envBloom.Intensity = math.clamp(envBaseBloom * envStrength / 45, 0, 1)
	__AuraFix_envColor.Brightness = p.brightness
	__AuraFix_envColor.Contrast = p.contrast
	__AuraFix_envColor.Saturation = p.saturation
	__AuraFix_envColor.TintColor = p.tint
	__AuraFix_envRays.Intensity = p.rays
	__AuraFix_envRays.Spread = p.spread
	__AuraFix_envBloom.Enabled = envOn and envStrength > 0
	__AuraFix_envColor.Enabled = envOn and index ~= 0
	__AuraFix_envRays.Enabled = envOn and p.rays > 0
	for i, b in ipairs(envButtons) do
		if b and b.Parent then
			tw(b, {BackgroundColor3 = i == index and accent or C.card2}, .28, EASE.Quint)
		end
	end
end

local function selectEnvironmentPreset(index)
	envOn = true
	cfg.envBloom = true
	if ctl.envBloom then ctl.envBloom.Set(true, true) end
	applyEnvironmentPreset(index)
	toast(T("Активен эффект: ") .. T((envPresets[index] or envPresets[0]).name), C.good)
end

__AuraFix_pv = page("Визуал")
section(__AuraFix_pv, "ОТОБРАЖЕНИЕ")
toggle(__AuraFix_pv, "Подсветка игроков", true, function(v) V.hl = v; refresh() end, "hl")
toggle(__AuraFix_pv, "Рамка игрока", true, function(v) V.box = v; refresh() end, "box")
toggle(__AuraFix_pv, "Полоса здоровья", true, function(v) V.health = v; refresh() end, "health")
toggle(__AuraFix_pv, "Трассеры", false, function(v) V.tracers = v; refresh() end, "tracers")
toggle(__AuraFix_pv, "Скелет", false, function(v) V.skel = v; refresh() end, "skel")
toggle(__AuraFix_pv, "Имена", true, function(v) V.names = v; refresh() end, "names")
toggle(__AuraFix_pv, "Дистанция", false, function(v) V.dist = v; refresh() end, "dist")
toggle(__AuraFix_pv, "Здоровье в имени", false, function(v) V.healthText = v; refresh() end, "healthText")
toggle(__AuraFix_pv, "Проверка команды", false, function(v) V.teamCheck = v; refresh() end, "teamCheck")
slider(__AuraFix_pv, "Дальность", 50, 1000, 250, function(v) return string.format("%d %s", v, T("ст.")) end, function(v) V.range = v end, 10, "range")
segment(__AuraFix_pv, "Стиль", {"Контур", "Заливка", "Градиент"}, function(i) V.style = i end, 1, "style")
section(__AuraFix_pv, "ЦВЕТ И ПЛАВНОСТЬ")
slider(__AuraFix_pv, "Яркость ESP", 25, 100, 100, function(v) return string.format("%d%%", v) end, function(v) V.brightness = v / 100 end, 5, "espBrightness")
slider(__AuraFix_pv, "Размер подписей", 10, 18, 13, function(v) return string.format("%d px", v) end, function(v) V.labelSize = v end, 1, "labelSize")
slider(__AuraFix_pv, "Толщина рамки", 1, 4, 1.5, function(v) return string.format("%.1f px", v) end, function(v) V.lineWidth = v end, .5, "lineWidth")
slider(__AuraFix_pv, "Толщина скелета", 1, 4, 1.5, function(v) return string.format("%.1f px", v) end, function(v) V.skelWidth = v end, .5, "skelWidth")
	section(__AuraFix_pv, "ВИЗУАЛЬНЫЕ ЭФФЕКТЫ")
	toggle(__AuraFix_pv, "Мягкое свечение и цвет", envOn, function(v)
		envOn = v
		cfg.envBloom = v
		applyEnvironmentPreset(envPreset)
	end, "envBloom")
	slider(__AuraFix_pv, "Интенсивность эффекта", 0, 100, envStrength, function(v) return string.format("%d%%", v) end, function(v)
		envStrength = v
		cfg.envBloomStrength = v
		__AuraFix_envBloom.Intensity = math.clamp(envBaseBloom * envStrength / 45, 0, 1)
		__AuraFix_envBloom.Enabled = envOn and envStrength > 0
	end, 5, "envBloomStrength")
	section(__AuraFix_pv, "ПРЕСЕТЫ ОКРУЖЕНИЯ")
	local envRow1 = row(__AuraFix_pv, 32)
	envButtons[1] = button(envRow1, "Золотой час", function() selectEnvironmentPreset(1) end, false, UDim2.new(.5, -3, 1, 0))
	envButtons[2] = button(envRow1, "Полночь", function() selectEnvironmentPreset(2) end, false, UDim2.new(.5, -3, 1, 0))
	local envRow2 = row(__AuraFix_pv, 32)
	envButtons[3] = button(envRow2, "Ужас", function() selectEnvironmentPreset(3) end, false, UDim2.new(.5, -3, 1, 0))
	envButtons[4] = button(envRow2, "Под водой", function() selectEnvironmentPreset(4) end, false, UDim2.new(.5, -3, 1, 0))
	local envRow3 = row(__AuraFix_pv, 32)
	envButtons[5] = button(envRow3, "Научная фантастика", function() selectEnvironmentPreset(5) end, false, UDim2.new(.5, -3, 1, 0))
	envButtons[6] = button(envRow3, "Северное сияние", function() selectEnvironmentPreset(6) end, false, UDim2.new(.5, -3, 1, 0))
	button(__AuraFix_pv, "Отключить эффекты", function()
		envOn = false
		cfg.envBloom = false
		if ctl.envBloom then ctl.envBloom.Set(false, true) end
		applyEnvironmentPreset(envPreset)
		toast("Эффект сброшен")
	end, false)
__AuraFix_espActions = row(__AuraFix_pv, 32)
button(__AuraFix_espActions, "Всё включить", function()
	for _, key in ipairs({"hl", "box", "health", "tracers", "skel", "names", "dist", "healthText"}) do
		if ctl[key] then ctl[key].Set(true) end
	end
	refresh()
	toast("Включено", C.good)
end, true, UDim2.new(.5, -3, 1, 0))
button(__AuraFix_espActions, "Всё скрыть", function()
	for _, key in ipairs({"hl", "box", "health", "tracers", "skel", "names", "dist", "healthText"}) do
		if ctl[key] then ctl[key].Set(false) end
	end
	refresh()
	toast("Выключено", C.warn)
end, false, UDim2.new(.5, -3, 1, 0))

__AuraFix_pm = page("Разное")
section(__AuraFix_pm, "ОБЩЕЕ")
toggle(__AuraFix_pm, "Анти-АФК", true, function(v) afkOn = v end, "afk")
toggle(__AuraFix_pm, "Показывать FPS", false, function(v) V.fps = v; showFps(v) end, "fps")
toggle(__AuraFix_pm, "Авто-перезаход", false, function(v) rejoinOn = v end, "rejoin")
slider(__AuraFix_pm, "Поле зрения", 50, 120, 70, function(v) return string.format("%.0f°", v) end, function(v) fovT = v; fovOn = true end, 1, "fov")
segment(__AuraFix_pm, "Язык", {"Русский", "English"}, setLang, 1, "lang")
__AuraFix_cr = row(__AuraFix_pm, 32)
__AuraFix_half = UDim2.new(.5, -3, 1, 0)
button(__AuraFix_cr, "Сохранить конфиг", function()
	local ok = saveCfg()
	toast(ok and "Конфиг сохранён" or "Сохранение недоступно", ok and C.good or C.bad)
end, true, __AuraFix_half)
button(__AuraFix_cr, "Загрузить конфиг", function()
	if loadCfg() then
		for k, o in pairs(ctl) do if cfg[k] ~= nil then o.Set(cfg[k]) end end
		-- Restore environment preset and values too; they are not ordinary UI controllers.
		envPreset = math.clamp(math.floor(tonumber(cfg.envPreset) or 0), 0, 6)
		envOn = cfg.envBloom == true
		envStrength = math.clamp(tonumber(cfg.envBloomStrength) or 45, 0, 100)
		applyEnvironmentPreset(envPreset)
		rainbow = cfg.rainbow == true
		if rainbow then mark(7)
		elseif type(cfg.accent) == "table" and cfg.accent[3] then setAccent(Color3.new(cfg.accent[1], cfg.accent[2], cfg.accent[3]), 0) end
		toast("Конфиг загружен", C.good)
	else
		toast("Конфиг не найден", C.bad)
	end
end, false, __AuraFix_half)

__AuraFix_ps = page("Настройки")
section(__AuraFix_ps, "ЦВЕТ АКЦЕНТА")
__AuraFix_swc = card(__AuraFix_ps, 46)
new("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center,
	VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 10)}, __AuraFix_swc)
for k, col in ipairs(cols) do
	local b = new("TextButton", {Text = "", AutoButtonColor = false, BackgroundColor3 = col, Size = UDim2.fromOffset(26, 26)}, __AuraFix_swc)
	round(b, 13); press(b, true)
	swb[k] = {S = stroke(b, 2, WHITE, 1)}
	cn(b.Activated, function() rainbow = false; cfg.rainbow = false; setAccent(col, k); toast("Акцент изменён") end)
end
__AuraFix_rb = new("TextButton", {Text = "", AutoButtonColor = false, BackgroundColor3 = WHITE, Size = UDim2.fromOffset(26, 26)}, __AuraFix_swc)
round(__AuraFix_rb, 13); press(__AuraFix_rb, true)
new("UIGradient", {Rotation = 45, Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
	ColorSequenceKeypoint.new(.33, Color3.fromRGB(80, 255, 120)), ColorSequenceKeypoint.new(.66, Color3.fromRGB(80, 140, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 200))})}, __AuraFix_rb)
swb[7] = {S = stroke(__AuraFix_rb, 2, WHITE, 1)}
cn(__AuraFix_rb.Activated, function()
	rainbow = not rainbow
	cfg.rainbow = rainbow
	if rainbow then mark(7) else mark(0) end
	toast(rainbow and "Радужный режим" or "Радуга выключена")
end)
do
	local sel = 0
	for k, c in ipairs(cols) do
		if (c.R - accent.R) ^ 2 + (c.G - accent.G) ^ 2 + (c.B - accent.B) ^ 2 < 1e-4 then sel = k end
	end
	mark(rainbow and 7 or sel)
end
slider(__AuraFix_ps, "Оттенок", 0, 360, (accent:ToHSV()) * 360, function(v) return string.format("%.0f°", v) end, function(v)
	rainbow = false; cfg.rainbow = false
	setAccent(Color3.fromHSV(v / 360, .65, 1), 0, true)
end, 1)
section(__AuraFix_ps, "ОКНО")
slider(__AuraFix_ps, "Прозрачность", 0, 50, 0, function(v) return string.format("%.0f%%", v) end, function(v)
	baseGT = v / 100
	if opened then tw(main, {GroupTransparency = baseGT}, .2) end
end, 1, "gt")
slider(__AuraFix_ps, "Размер меню", 60, 130, baseScale * 100, function(v) return string.format("%.0f%%", v) end, function(v)
	local camera = workspace.CurrentCamera
	local size = camera and camera.ViewportSize or Vector2.new(800, 400)
	local fit = math.clamp(math.min((size.Y - 40) / WIN_H, (size.X - 16) / WIN_W), .52, 1)
	baseScale = math.min(v / 100, fit)
	tw(mscale, {Scale = baseScale}, .32, EASE.Quint)
	startPos = UDim2.new(.5, 0, 0, math.max(6, (size.Y - WIN_H * baseScale) / 2))
end, 5, "size")
toggle(__AuraFix_ps, "Размытие фона", true, function(v)
	blurOn = v
	if opened then tw(blur, {Size = v and 14 or 0}, .3) end
end, "blur")
section(__AuraFix_ps, "ПОВЕДЕНИЕ")
toggle(__AuraFix_ps, "Авто-скрытие после выбора", false, function(v) cfg.autoHide = v end, "autoHide")
toggle(__AuraFix_ps, "Показывать подсказки", true, function(v) cfg.hints = v end, "hints")
slider(__AuraFix_ps, "Скорость анимаций", 50, 150, 100, function(v) return string.format("%d%%", v) end, function(v)
	cfg.animSpeedFactor = v / 100
end, 5, "animSpeed")
__AuraFix_settingsQuick = row(__AuraFix_ps, 32)
button(__AuraFix_settingsQuick, "Сбросить позицию", function() tw(holder, {Position = startPos}, .6, EASE.Back) end, false, UDim2.new(.5, -3, 1, 0))
button(__AuraFix_settingsQuick, "Сбросить конфиг", function()
	cfg = {}
	rainbow = false
	for _, control in pairs(ctl) do
		if control.Default ~= nil and control.Set then pcall(function() control.Set(control.Default) end) end
	end
	cfg.rainbow = false
	-- Reset the visual preset as well as standard toggles so effects do not linger.
	envPreset, envOn, envStrength = 0, false, 45
	cfg.envPreset, cfg.envBloom, cfg.envBloomStrength = 0, false, 45
	if ctl.envBloom then ctl.envBloom.Set(false, true) end
	if ctl.envBloomStrength then ctl.envBloomStrength.Set(45, true) end
	applyEnvironmentPreset(0)
	setAccent(Color3.fromRGB(130, 100, 255), 1)
	pcall(saveCfg)
	toast("Всё сброшено", C.warn)
end, false, UDim2.new(.5, -3, 1, 0))
section(__AuraFix_ps, "ИНФОРМАЦИЯ О ПЛЕЕРЕ")
__AuraFix_aboutCard = card(__AuraFix_ps, 56)
__AuraFix_aboutOrb = new("Frame", {Position = UDim2.fromOffset(10, 10), Size = UDim2.fromOffset(36, 36), BackgroundColor3 = accent}, __AuraFix_aboutCard)
round(__AuraFix_aboutOrb, 18)
new("UIGradient", {Rotation = 45, Color = ColorSequence.new(light(accent), dark(accent))}, __AuraFix_aboutOrb)
lbl(__AuraFix_aboutOrb, "A", 18, WHITE, {TextXAlignment = Enum.TextXAlignment.Center, Font = Enum.Font.GothamBlack})
lbl(__AuraFix_aboutCard, lp.DisplayName, 12, C.text, {Position = UDim2.fromOffset(56, 8), Size = UDim2.new(1, -66, 0, 18), Font = Enum.Font.GothamBold})
lbl(__AuraFix_aboutCard, "@" .. lp.Name .. " · " .. tostring(lp.UserId), 10, C.sub, {Position = UDim2.fromOffset(56, 27), Size = UDim2.new(1, -66, 0, 16)})
button(__AuraFix_ps, "Выгрузить меню", function() setOpen(false); task.delay(.4, unload) end)

__AuraFix_tabBtns, __AuraFix_cur, __AuraFix_tok = {}, nil, nil
__AuraFix_ind = new("Frame", {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = .8}, side)
round(__AuraFix_ind, 8); acc(__AuraFix_ind, "BackgroundColor3")
__AuraFix_ibar = new("Frame", {Size = UDim2.new(0, 3, .6, 0), AnchorPoint = Vector2.new(0, .5), Position = UDim2.new(0, 4, .5, 0)}, __AuraFix_ind)
round(__AuraFix_ibar, 2); acc(__AuraFix_ibar, "BackgroundColor3")

function __AuraFix_popIn(name)
	local n = 0
	for _, c in ipairs(pages[name]:GetChildren()) do
		if c:IsA("GuiObject") and c.Visible then
			n += 1
			if n > 9 then break end
			local sc = c:FindFirstChild("Pop") or new("UIScale", {Name = "Pop"}, c)
			sc.Scale = .94
			task.delay(n * .022, function() if c.Parent and pages[name].Visible then tw(sc, {Scale = 1}, .46, EASE.Quint) end end)
		end
	end
end

function __AuraFix_selectTab(name, instant)
	if __AuraFix_cur == name then return end
	__AuraFix_cur = name
	local my = {}
	__AuraFix_tok = my
	for n, b in pairs(__AuraFix_tabBtns) do tw(b, {TextColor3 = n == name and C.text or C.sub}, .25) end
	tw(__AuraFix_ind, {Position = UDim2.fromOffset(0, (table.find(order, name) - 1) * 36)}, .4, EASE.Back)
	local function swap() for n, p in pairs(pages) do p.Visible = n == name end end
	if instant then swap(); __AuraFix_popIn(name) return end
	task.spawn(function()
		tw(content, {GroupTransparency = 1, Position = CPOS + UDim2.fromOffset(0, 8)}, .14).Completed:Wait()
		if __AuraFix_tok ~= my then return end
		swap()
		content.Position = CPOS - UDim2.fromOffset(0, 8); __AuraFix_popIn(name)
		tw(content, {GroupTransparency = 0, Position = CPOS}, .34, EASE.Quint)
	end)
end

__AuraFix_tabGlyphs = { ["Музыка"] = "♫", ["Эффекты"] = "✦", ["Визуал"] = "◈", ["Разное"] = "◌", ["Настройки"] = "⚙" }
for i, name in ipairs(order) do
	local b = new("TextButton", {Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.sub, TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1, AutoButtonColor = false, Position = UDim2.fromOffset(0, (i - 1) * 36), Size = UDim2.new(1, 0, 0, 32)}, side)
	bind(b, name)
	new("UIPadding", {PaddingLeft = UDim.new(0, 31)}, b)
	local glyph = new("TextLabel", {BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = C.sub,
		Text = __AuraFix_tabGlyphs[name] or "•", Position = UDim2.fromOffset(8, 0), Size = UDim2.fromOffset(18, 32), TextXAlignment = Enum.TextXAlignment.Center}, side)
	acc(glyph, "TextColor3", function() return __AuraFix_cur == name and accent or C.sub end)
	__AuraFix_tabBtns[name] = b
	cn(b.Activated, function() __AuraFix_selectTab(name) end)
	cn(b.MouseEnter, function()
		if __AuraFix_cur ~= name then
			tw(b, {TextColor3 = C.text:Lerp(C.sub, .45)}, .2)
			tw(glyph, {TextColor3 = accent}, .2)
		end
	end)
	cn(b.MouseLeave, function()
		tw(b, {TextColor3 = __AuraFix_cur == name and C.text or C.sub}, .25)
		tw(glyph, {TextColor3 = __AuraFix_cur == name and accent or C.sub}, .25)
	end)
end

cn(sound.Ended, function()
	if sound.Looped then return end
	endedF = true
	if queueAutoPlay and #queueItems > 0 then
		task.delay(.15, function()
			if not sound.IsPlaying and #queueItems > 0 and gui.Parent then
				local nextItem = table.remove(queueItems, 1)
				__AuraFix_renderQueue()
				box.Text = nextItem.id
				play(nextItem.id)
			end
		end)
	end
end)
cn(UIS.InputBegan, function(i, gp)
	if not gp and i.KeyCode == Enum.KeyCode.RightShift then setOpen(not opened) end
end)

__AuraFix_spinV = 0
RS:BindToRenderStep("AuraMenuLoop", Enum.RenderPriority.Camera.Value + 1, function(dt)
	local t = os.clock()
	if rainbow then
		hue = (hue + dt * .2) % 1
		accent = Color3.fromHSV(hue, .65, 1)
		for _, f in ipairs(reg) do f(true) end
	end
	if fovOn then
		local c = workspace.CurrentCamera
		if c then c.FieldOfView += (fovT - c.FieldOfView) * math.min(1, dt * 8) end
	end
	if espAny or espWas then updateESP(t) end
	espWas = espAny
	if V.fps then
		fpsA += dt; fpsN += 1
		if fpsA >= .4 then
			local f = math.floor(fpsN / fpsA + .5)
			fpsA, fpsN = 0, 0
			local ok, ping = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
			fpsL.Text = f .. " FPS · " .. (ok and math.floor(ping + .5) .. " ms" or "-- ms")
			fpsD.BackgroundColor3 = f >= 50 and C.good or (f >= 30 and Color3.fromRGB(255, 190, 70) or C.bad)
		end
	end
	local playing = sound.IsPlaying
	local loud = math.clamp(sound.PlaybackLoudness / 350, 0, 1)	
	-- Original Aurora mode: slow hue drift and a restrained glow pulse, only while enabled.
	if envOn and envPreset == 6 then
		envPhase += math.max(0, dt) * .12
		envTick += dt
		if envTick >= .045 then
			envTick = 0
			local wave = (math.sin(envPhase * 2.7) + 1) * .5
			__AuraFix_envColor.TintColor = Color3.fromHSV(.43 + wave * .22, .28 + wave * .18, 1)
			__AuraFix_envColor.Saturation = .12 + wave * .14
			__AuraFix_envBloom.Intensity = math.clamp(envBaseBloom * envStrength / 45 * (.78 + wave * .32), 0, 1)
		end
	end
	if miniPlayer and miniPlayer.Parent then
		local currentTitle = nameL and nameL.Text or T("Ничего не играет")
		miniPlayerTitle.Text = currentTitle ~= "" and currentTitle or T("Ничего не играет")
		miniPlayerPlay.Text = playing and "Ⅱ" or "▶"
		miniPlayerPlay.BackgroundColor3 = playing and accent or C.card2
		miniPlayerDot.BackgroundColor3 = playing and C.good or (sound.IsPaused and C.warn or C.sub)
	end
	if not main.Visible then return end
	for k, m in ipairs(mini) do
		local target = playing and 3 + (.5 + .5 * math.sin(t * (6 + k * 1.7) + k)) * 9 * (.4 + loud * .6) or 3
		m.h += (target - m.h) * .25
		m.f.Size = UDim2.fromOffset(4, math.floor(m.h + .5))
	end
	if not pages["Музыка"].Visible then return end
	for n, b in ipairs(__AuraFix_bars) do
		local wave = math.abs(math.sin(t * 5 + n * .8) * math.cos(t * 2.3 + n * .37))
		local target = playing and loud * (.35 + .65 * wave) or 0
		if visualizerStyle == 2 then target = playing and loud * (.25 + .75 * math.abs(math.sin(t * 6 + n * 1.25))) or 0 end
		if visualizerStyle == 3 then target = playing and loud * (.2 + .8 * math.abs(math.sin(t * 3.5 + n * .38) * math.sin(n * .23))) or 0 end
		local ease = 1 - math.exp(-dt * 13)
		b.h += (target - b.h) * ease
		b.p = math.max(b.h, b.p - dt * 1.15)
		b.f.Size = UDim2.new(1 / 28, -3, 0, 3 + b.h * 36)
		b.c.Position = UDim2.new((n - 1) / 28, 2, 1, -11 - b.p * 36)
	end
	__AuraFix_spinV += ((playing and 150 or 0) - __AuraFix_spinV) * math.min(1, dt * 3)
	__AuraFix_vinyl.Rotation = (__AuraFix_vinyl.Rotation + __AuraFix_spinV * dt) % 360
	__AuraFix_vs.Thickness = musicAccentPulse and (2 + loud * 3) or 2
	local len = sound.TimeLength
	if not prog.Dragging then prog.Set(len > 0 and sound.TimePosition / len or 0, true, true) end
	local want = T(playing and "Пауза" or "Играть")
	if pauseB.Text ~= want then pauseB.Text = want end
	if trackOK then
		local s = playing and "Играет" or (sound.IsPaused and "На паузе" or (endedF and "Трек закончился" or "Остановлено"))
		s = T(s)
		if statusL.Text ~= s then setStatus(s, playing and C.good or C.sub) end
	end
end)

applyEnvironmentPreset(envPreset)
__AuraFix_selectTab(order[1], true)
setOpen(true)
task.delay(.9, function() toast("AURA загружено") end)
