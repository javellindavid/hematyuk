Add-Type -AssemblyName System.Drawing

$width  = 1280
$height = 720
$dst    = 'c:\Users\asus\OneDrive\Documents\GitHub\HematYuk\icons\screenshot-wide.png'

$bmp = New-Object System.Drawing.Bitmap($width, $height)
$g   = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode   = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias

# -- Background
$bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(240,253,244))
$g.FillRectangle($bgBrush, 0, 0, $width, $height)

# -- Top bar
$topBarBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.FillRectangle($topBarBrush, 0, 0, $width, 64)
$topBorderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(226,232,240))
$g.DrawLine($topBorderPen, 0, 64, $width, 64)

# -- Logo circle
$logoBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Point(20,12)),
    (New-Object System.Drawing.Point(60,52)),
    [System.Drawing.Color]::FromArgb(4,120,87),
    [System.Drawing.Color]::FromArgb(16,185,129)
)
$g.FillEllipse($logoBrush, 20, 12, 40, 40)

# -- Brand name
$fontBold   = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$fontSemi   = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$fontMed    = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Regular)
$fontSmall  = New-Object System.Drawing.Font("Segoe UI",  9, [System.Drawing.FontStyle]::Regular)
$greenBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(4,120,87))
$darkBrush  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(15,23,42))
$grayBrush  = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(100,116,139))
$whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)

$g.DrawString("HematYuk!", $fontBold, $greenBrush, 72, 10)
$g.DrawString("Smart Inventory & Finance", $fontSmall, $grayBrush, 74, 38)

# ---- LEFT PANEL (Finance Summary) ----
$leftX = 20
$cardW = 390

# Finance card gradient
$finGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    (New-Object System.Drawing.Rectangle($leftX, 80, $cardW, 180)),
    [System.Drawing.Color]::FromArgb(4,120,87),
    [System.Drawing.Color]::FromArgb(16,185,129),
    [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
)
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$path.AddRoundedRectangle = $null
$g.FillRectangle($finGrad, $leftX, 80, $cardW, 180)

# Finance card text
$fontLabel = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
$fontBig   = New-Object System.Drawing.Font("Segoe UI", 26, [System.Drawing.FontStyle]::Bold)
$g.DrawString("TOTAL SALDO", $fontLabel, $whiteBrush, ($leftX+16), 96)
$g.DrawString("Rp 2.450.000", $fontBig,  $whiteBrush, ($leftX+10), 114)

# Mini income/expense cards
$miniW = 175
$miniBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40,255,255,255))
$g.FillRectangle($miniBrush, ($leftX+12), 180, $miniW, 64)
$g.FillRectangle($miniBrush, ($leftX+200), 180, $miniW, 64)
$incGreen = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(167,243,208))
$expRed   = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(252,165,165))
$fontMini = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Regular)
$fontVal  = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$g.DrawString("Pemasukan", $fontMini, $whiteBrush, ($leftX+20), 186)
$g.DrawString("Rp 3.500.000", $fontVal, $incGreen, ($leftX+14), 202)
$g.DrawString("Pengeluaran", $fontMini, $whiteBrush, ($leftX+208), 186)
$g.DrawString("Rp 1.050.000", $fontVal, $expRed, ($leftX+202), 202)

# Quick Actions Grid
$fontCard = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$fontSub  = New-Object System.Drawing.Font("Segoe UI",  8, [System.Drawing.FontStyle]::Regular)
$cardBG   = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$borderPen= New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(226,232,240))
$qa = @(
    @{x=20;  y=276; icon="+ Pemasukan"; sub="Catat uang masuk"},
    @{x=210; y=276; icon="- Pengeluaran"; sub="Catat uang keluar"},
    @{x=20;  y=356; icon="# Produk"; sub="Kelola inventaris"},
    @{x=210; y=356; icon="! Strategi"; sub="Tips bisnis"}
)
foreach ($q in $qa) {
    $g.FillRectangle($cardBG, $q.x, $q.y, 178, 68)
    $g.DrawRectangle($borderPen, $q.x, $q.y, 178, 68)
    $g.DrawString($q.icon, $fontCard, $greenBrush, ($q.x+10), ($q.y+10))
    $g.DrawString($q.sub,  $fontSub,  $grayBrush,  ($q.x+10), ($q.y+36))
}

# ---- MIDDLE PANEL (Products) ----
$midX = 430
$midW = 390
$cardBG2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$sectionFont = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Bold)
$sectionBrush= New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(148,163,184))

$g.DrawString("PRODUK INVENTARIS", $sectionFont, $sectionBrush, $midX, 84)

$products = @(
    @{name="Susu UHT 1L"; cat="Makanan"; stock="24 pcs"; status="ok"},
    @{name="Sabun Mandi"; cat="Kosmetik"; stock="12 pcs"; status="warn"},
    @{name="Baju Kain Premium"; cat="Pakaian"; stock="8 pcs"; status="ok"},
    @{name="Vitamin C 500mg"; cat="Obat"; stock="50 pcs"; status="ok"},
    @{name="Kopi Arabika"; cat="Minuman"; stock="5 pcs"; status="warn"}
)
$py = 104
foreach ($p in $products) {
    $g.FillRectangle($cardBG2, $midX, $py, $midW, 50)
    $g.DrawRectangle($borderPen, $midX, $py, $midW, 50)
    $iconBG = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(209,250,229))
    $g.FillRectangle($iconBG, ($midX+8), ($py+7), 36, 36)
    $g.DrawString($p.name, $fontMed, $darkBrush, ($midX+52), ($py+6))
    $g.DrawString("$($p.cat) | Stok: $($p.stock)", $fontSmall, $grayBrush, ($midX+52), ($py+26))
    if ($p.status -eq "ok") {
        $stBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(5,150,105))
        $g.DrawString("OK", $fontSmall, $stBrush, ($midX+350), ($py+18))
    } else {
        $stBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(245,158,11))
        $g.DrawString("WARN", $fontSmall, $stBrush, ($midX+340), ($py+18))
    }
    $py += 58
}

# ---- RIGHT PANEL (Transactions) ----
$rightX = 840
$rightW = 420
$g.DrawString("RIWAYAT TRANSAKSI", $sectionFont, $sectionBrush, $rightX, 84)

$txns = @(
    @{desc="Penjualan Baju Kain"; date="22 Apr 2026"; amount="+Rp 350.000"; isIncome=$true},
    @{desc="Beli Bahan Baku"; date="21 Apr 2026"; amount="-Rp 120.000"; isIncome=$false},
    @{desc="Penjualan Susu UHT"; date="21 Apr 2026"; amount="+Rp 240.000"; isIncome=$true},
    @{desc="Operasional Toko"; date="20 Apr 2026"; amount="-Rp 80.000"; isIncome=$false},
    @{desc="Penjualan Kopi"; date="20 Apr 2026"; amount="+Rp 175.000"; isIncome=$true}
)
$ty = 104
foreach ($t in $txns) {
    $g.FillRectangle($cardBG2, $rightX, $ty, $rightW, 50)
    $g.DrawRectangle($borderPen, $rightX, $ty, $rightW, 50)
    if ($t.isIncome) {
        $txIconBG = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(209,250,229))
        $amtBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(5,150,105))
    } else {
        $txIconBG = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(254,226,226))
        $amtBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(239,68,68))
    }
    $g.FillRectangle($txIconBG, ($rightX+8), ($ty+7), 36, 36)
    $g.DrawString($t.desc, $fontMed, $darkBrush, ($rightX+52), ($ty+6))
    $g.DrawString($t.date, $fontSmall, $grayBrush, ($rightX+52), ($ty+26))
    $g.DrawString($t.amount, $fontMed, $amtBrush, ($rightX+310), ($ty+14))
    $ty += 58
}

# -- Bottom nav
$navBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.FillRectangle($navBrush, 0, 660, $width, 60)
$g.DrawLine($topBorderPen, 0, 660, $width, 660)
$navItems = @("Beranda","Produk","Keuangan","Strategi")
$navX = 50
foreach ($n in $navItems) {
    if ($n -eq "Beranda") {
        $g.DrawString($n, $fontSemi, $greenBrush, $navX, 676)
    } else {
        $g.DrawString($n, $fontSemi, $grayBrush, $navX, 676)
    }
    $navX += 300
}

$g.Dispose()
$bmp.Save($dst, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()

Write-Host "Done! Saved to $dst"
$check = [System.Drawing.Image]::FromFile($dst)
Write-Host "Size: $($check.Width) x $($check.Height)"
$check.Dispose()
