# ⚡ دليل استخدام Fast-Downloader في Termux ⚡

## 📥 خطوات التثبيت والاستخدام

### 1. تحديث الحزم وتثبيت المتطلبات
```bash
pkg update && pkg install git aria2 -y
```

### 2. منح صلاحيات التخزين
```bash
termux-setup-storage
```
> ⚠️ سيطلب منك السماح لـ Termux بالوصول إلى التخزين - يجب الموافقة

### 3. تنزيل وتشغيل الأداة
```bash
git clone https://github.com/Nayil1998/fast-downloader.git
cd fast-downloader
chmod +x download.sh
./download.sh
```

## 🛠️ كيفية الاستخدام
بعد تشغيل `./download.sh`:
1. أدخل رابط الملف الذي تريد تحميله
2. انتظر حتى يكتمل التحميل
3. الملفات المحملة ستكون في مجلد `storage/downloads`

## ❓ استكشاف الأخطاء
إذا واجهتك مشاكل:
- تأكد من اتصال الإنترنت
- جرب إعادة تشغيل Termux
- تأكد من منح جميع الصلاحيات المطلوبة
