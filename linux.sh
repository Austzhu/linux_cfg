#!/bin/bash
echo "必须在root权限下运行"

read -p "是否要安装vim  y?n  " flag
if [ "$flag" == "y" -o "$flag" == "" ];then
	echo "install vim..."
	apt-get update
	apt-get install vim -y
	echo "install vim success."
fi

read -p "是否要解决登陆不能登入root问题.  y?n  " flag
if [ "$flag" == "y" -o "$flag" == "" ];then
	#解决ubuntu不能登入root用户的问题
	echo "greeter-show-manual-login=true" >>/usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
	#解决 stdin：is not a tty
	sed -i 's/mesg n/tty -s && mesg n/' /root/.profile
fi 

read -p "是否要安装sublime_text.  y?n  " flag
if [ "$flag" == "y" -o "$flag" == "" ];then
	echo "确认sublime_text安装包的路径..."
	SUBDIR=./soft/sublime-text_build-3126_amd64.deb
	read -p "默认路径 ${SUBDIR}  y?n  " flag
	if [ "$flag" != "y" ];then
		echo "输入sublime_text路径"
		read SUBDIR
	fi
	dpkg -i $SUBDIR
fi

read -p "是否要安装搜狗输入法.  y?n  " flag
if [ "$flag" == "y" -o "$flag" == "" ];then
	echo "确认sogoupinyin安装包的路径..."
	SOGOUDIR=~/winshare/x64/sogoupinyin_2.0.0.0068_amd64.deb
	read -p "默认路径${SOGOUDIR} y?n  " flag
	if [ "$flag" != "y" ];then
		echo "输入sogoupinyin路径"
		read SOGOUDIR
	fi
	dpkg -i $SOGOUDIR
fi

read -p "是否要解决sublime_text不能输入中文的问题.  y?n  " flag
if [ "$flag" == "y" -o "$flag" == "" ];then
	echo "solve sublimetext can not type chinese..."
	#解决sublime下不能输入中文的问题
	apt-get install build-essential -y
	apt-get install libgtk2.0-dev -y

	echo "#include <gtk/gtk.h>
	#include <gdk/gdkx.h>
	typedef GdkSegment GdkRegionBox;
	 
	struct _GdkRegion
	{
	  long size;
	  long numRects;
	  GdkRegionBox *rects;
	  GdkRegionBox extents;
	};
	 
	GtkIMContext *local_context;
	 
	void gdk_region_get_clipbox (const GdkRegion *region,GdkRectangle    *rectangle)
	{
	  g_return_if_fail (region != NULL);
	  g_return_if_fail (rectangle != NULL);
	 
	  rectangle->x = region->extents.x1;
	  rectangle->y = region->extents.y1;
	  rectangle->width = region->extents.x2 - region->extents.x1;
	  rectangle->height = region->extents.y2 - region->extents.y1;
	  GdkRectangle rect;
	  rect.x = rectangle->x;
	  rect.y = rectangle->y;
	  rect.width = 0;
	  rect.height = rectangle->height;
	  //The caret width is 2;
	  //Maybe sometimes we will make a mistake, but for most of the time, it should be the caret.
	  if(rectangle->width == 2 && GTK_IS_IM_CONTEXT(local_context)) {
	        gtk_im_context_set_cursor_location(local_context, rectangle);
	  }
	}
	 
	//this is needed, for example, if you input something in file dialog and return back the edit area
	//context will lost, so here we set it again.
	 
	static GdkFilterReturn event_filter (GdkXEvent *xevent, GdkEvent *event, gpointer im_context)
	{
	    XEvent *xev = (XEvent *)xevent;
	    if(xev->type == KeyRelease && GTK_IS_IM_CONTEXT(im_context)) {
	       GdkWindow * win = g_object_get_data(G_OBJECT(im_context),\"window\");
	       if(GDK_IS_WINDOW(win))
	         gtk_im_context_set_client_window(im_context, win);
	    }
	    return GDK_FILTER_CONTINUE;
	}
	 
	void gtk_im_context_set_client_window (GtkIMContext *context,GdkWindow    *window)
	{
	  GtkIMContextClass *klass;
	  g_return_if_fail (GTK_IS_IM_CONTEXT (context));
	  klass = GTK_IM_CONTEXT_GET_CLASS (context);
	  if (klass->set_client_window)
	    klass->set_client_window (context, window);
	 
	  if(!GDK_IS_WINDOW (window))
	    return;
	  g_object_set_data(G_OBJECT(context),\"window\",window);
	  int width = gdk_window_get_width(window);
	  int height = gdk_window_get_height(window);
	  if(width != 0 && height !=0) {
	    gtk_im_context_focus_in(context);
	    local_context = context;
	  }
	  gdk_window_add_filter (window, event_filter, context);
	}" > sublime-imfix.c

	gcc -shared -o libsublime-imfix.so sublime-imfix.c  `pkg-config --libs --cflags gtk+-2.0` -fPIC

	mv libsublime-imfix.so /opt/sublime_text/ -f
	rm sublime-imfix.c -f
	echo "#!/bin/sh
	LD_PRELOAD=/opt/sublime_text/libsublime-imfix.so exec /opt/sublime_text/sublime_text \"\$@\"" > /usr/bin/subl

	sed -i 's/Exec=\/opt\/sublime_text\/sublime_text %F/Exec=bash -c "LD_PRELOAD=\/opt\/sublime_text\/libsublime-imfix.so exec \/opt\/sublime_text\/sublime_text %F"/' /usr/share/applications/sublime_text.desktop
	sed -i 's/Exec=\/opt\/sublime_text\/sublime_text -n/Exec=bash -c "LD_PRELOAD=\/opt\/sublime_text\/libsublime-imfix.so exec \/opt\/sublime_text\/sublime_text -n"/' /usr/share/applications/sublime_text.desktop
	sed -i 's/Exec=\/opt\/sublime_text\/sublime_text --command new_file/Exec=bash -c "LD_PRELOAD=\/opt\/sublime_text\/libsublime-imfix.so exec \/opt\/sublime_text\/sublime_text --command new_file"/' /usr/share/applications/sublime_text.desktop
fi

read -p "是否要安装交叉编译工具.  y?n  " flag
if [ "$flag" == "y" -o "$flag" == "" ];then
	echo "确认\"交叉编译工具\"的路径..."
	ARMDIR=~/winshare/x64/arm-2009q3.tar.bz2
	read -p "默认路径~/winshare/soft/arm/arm-2009q3.tar.bz2  y?n  " flag
	if [ "$flag" != "y" ];then
		echo "输入sublime_text路径"
		read ARMDIR
	fi
	echo "你的sublime_text路径是：$ARMDIR"
	tar -xf $ARMDIR -C /usr/local

	echo "为交叉编译工具链创建软连接..."
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-addr2line 		/usr/bin/arm-linux-addr2line
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-ar			 	/usr/bin/arm-linux-ar
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-as				/usr/bin/arm-linux-as
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-c++				/usr/bin/arm-linux-c++
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-c++filt			/usr/bin/arm-linux-c++filt
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-cpp				/usr/bin/arm-linux-cpp
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-g++				/usr/bin/arm-linux-g++
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-gcc				/usr/bin/arm-linux-gcc
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-gcc-4.4.1		/usr/bin/arm-linux-gcc-4.4.1
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-gcov				/usr/bin/arm-linux-gcov
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-gdb				/usr/bin/arm-linux-gdb
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-gdbtui			/usr/bin/arm-linux-gdbtui
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-gprof			/usr/bin/arm-linux-gprof
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-ld				/usr/bin/arm-linux-ld
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-nm				/usr/bin/arm-linux-nm
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-objcopy			/usr/bin/arm-linux-objcopy
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-objdump			/usr/bin/arm-linux-objdump
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-ranlib			/usr/bin/arm-linux-ranlib
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-readelf			/usr/bin/arm-linux-readelf
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-size				/usr/bin/arm-linux-size
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-sprite			/usr/bin/arm-linux-sprite
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-strings			/usr/bin/arm-linux-strings
	ln -s /usr/local/arm-2009q3/bin/arm-none-linux-gnueabi-strip			/usr/bin/arm-linux-strip
fi


read -p "是否要安装tftp.  y?n  " flag
if [ "$flag" == "y" -o "$flag" == "" ];then
	apt-get install tftp-hpa tftpd-hpa -y
	apt-get install xinetd -y
	echo "#/etc/default/tftpd-hpa
	TFTP_USERNAME=\"tftp\"
	TFTP_DIRECTORY=\"/tftpboot\"
	TFTP_ADDRESS=\"0.0.0.0:69\"
	TFTP_OPTIONS=\"-l -c -s\"" > /etc/default/tftpd-hpa
	mkdir /tftpboot
	chmod 777 /tftpboot -R

	echo "service tftp
	{
		socket_type = dgram
		wait = yes
		disable = no
		user = root
		protocol = udp
		server = /usr/sbin/in.tftpd
		server_args = -s /tftpboot
		per_source = 11
		cps =100 2
		flags =IPv4
	}" > /etc/xinetd.d/tftp

	service tftpd-hpa restart
	/etc/init.d/xinetd reload
	/etc/init.d/xinetd restart
	/etc/init.d/tftpd-hpa restart
fi

read -p "是否要安装nfs.  y?n  " flag
if [ "$flag" == "y" -o "$flag" == ""  ];then
	apt-get install nfs-kernel-server -y
	apt-get install nfs-common -y
	echo "/rootfs *(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
	mkdir /rootfs 
	chmod 777 /rootfs -R
	showmount -e
	exportfs -r
	#showmount localhost -e
	/etc/init.d/nfs-kernel-server restart
fi

read -p "是否要安装ssh.  y?n  " flag
if [ "$flag" == "y" -o "$flag" == "" ];then
	apt-get install openssh-server openssh-client -y
	/etc/init.d/ssh restart
fi

read -p "其他配置  y?n  " flag
if [ "$flag" == "y" -o "$flag" == "" ];then
	source ~/.bashrc
	#安装ctags和cscope
	apt-get install ctags cscope -y
	#安装menuconfig支持的库
	apt-get install libncurses5-dev -y
	# automake 工具,tslib需要
	apt-get install autoconf automake libtool -y
fi

read -p "是否重启.  y?n  " flag
if [ "$flag" == "y" ];then
	reboot
fi

exit 0
