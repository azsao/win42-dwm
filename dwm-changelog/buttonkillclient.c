#define NBUTTONS(m) (!!(m&Button1Mask)+!!(m&Button2Mask)+!!(m&Button3Mask)+!!(m&Button4Mask)+!!(m&Button5Mask))

/* or, equivalently:
int
nbuttons(int mask)
{
	int i = 0;
	
	if(m & Button1Mask) ++i;
	if(m & Button2Mask) ++i;
	if(m & Button3Mask) ++i;
	if(m & Button4Mask) ++i;
	if(m & Button5Mask) ++i;
	return i;
}
*/

void
buttonkillclient(const Arg *arg)
{
	XEvent ev;
	
	if(XGrabPointer(dpy, root, False, BUTTONMASK, GrabModeAsync, GrabModeAsync,
	None, None, CurrentTime) != GrabSuccess)
		return;
	killclient(NULL);
	for(;;) {
		XNextEvent(dpy, &ev);
		if(ev.type == ButtonRelease && NBUTTONS(ev.xbutton.state) == 1)
			break;
		if(handler[ev.type])
			handler[ev.type](&ev);
	}
	XUngrabPointer(dpy, CurrentTime);
}