		
		
		var navMenus = $(".navigation .menu");
        var fadeDuration = 100;
        var body = $('body');

        $(".navigation").each(function(){
            var siteHeader = $(this);
            var navTrigger = $("#pull_menu");
            var isAnimation = false;
			var mynav		= $(".navigation .menu a");
            navTrigger.click(function(e){
				$(this).toggleClass('active');
				e.preventDefault();
                if (!isAnimation)
                {
                    isAnimation = true;

                    if (body.hasClass('show-sidebar'))
                    {
                        body.removeClass('show-sidebar');
                        //$.cookie(Garphee.Variables.CookieName, 'hide-sidebar', { 'path': '/' });
                        HideMenu();
                    }
                    else
                    {
                        body.addClass('show-sidebar');
                        //$.cookie(Garphee.Variables.CookieName, 'show-sidebar', { 'path': '/' });
                        ShowMenu();
                    }
                }
				
                setTimeout(function(){
                    isAnimation = false;
                }, 500);
            });
			
			
			mynav.click(function(e){
				
				$('.pull_menu').removeClass('active');
				body.removeClass('show-sidebar');
				HideMenu();		
				
			});
        });

        

        function ShowMenu()
        {
            navMenus.each(function(){
                var buttons = $(this).children().children('a');

                buttons.css('display', 'inline-block');
                buttons.eq(0).animate({ 'opacity': 1 }, fadeDuration, function(){
                    buttons.eq(1).animate({ 'opacity': 1 }, fadeDuration, function(){
                        buttons.eq(2).animate({ 'opacity': 1 }, fadeDuration, function(){
                           
                        });
                    });
                });
            });
        }
        function HideMenu()
        {
            navMenus.each(function(){
                var buttons = $(this).children().children('a');

               
                        buttons.eq(2).animate({ 'opacity': 0 }, fadeDuration, function(){
                            buttons.eq(1).animate({ 'opacity': 0 }, fadeDuration, function(){
                                buttons.eq(0).animate({ 'opacity': 0 }, fadeDuration, function(){
                                    buttons.css('display', 'none').removeClass('show');
                                });
                            });
                        });
                    });
            
        }
 