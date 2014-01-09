(function($) {
    $(function() {

        // table definition dropdown
        $('.table-definition-target').click(function () { showDefinition(this);});

        var $content = $("#content");

        $("a").filter("[rel]").each(function () {

            if (!$content.find(this.rel).hasClass('overlay')) {
                return;
            }
            $(this).overlay({
                // common configuration for each overlay
                oneInstance: false,
                closeOnClick: true,
                top: '15%',
                onBeforeLoad: function () {
                    var $overlay = this.getOverlay(),
                        $trigger, text, uppercase_text;
                    // create overlay title if not found in the overlay body
                    if (!$overlay.find('.overlay-title').length) {
                        $trigger = this.getTrigger();
                        text = $trigger.text();
                        uppercase_text = text.charAt(0).toUpperCase() + text.substring(1, text.length);
                        $("<h3 />").attr({'class': 'overlay-title'}).html(uppercase_text).prependTo($overlay);
                    }
                    // wrap overlay content so that we can have a maximum height with overflow
                    if (!$overlay.find('.overlay-body').length) {
                        $overlay.children().wrapAll('<div class="overlay-body" />');
                    }
                }

            });
        });


        // galleryView override
        if ($.fn.galleryView !== undefined) {
            $.fn.eeaGalleryView = function(opts) {
                return this.each(function(){
                    var $this = $(this);
                    var $gallery_parent = $this.parent(),
                        $gallery_class = $gallery_parent[0].className,
                        parent_width, parent_height,
                        gallery_width, gallery_height;
                    parent_width = $gallery_parent.width() - 10;
                    parent_height = Math.round((parent_width /4)*3);
                    gallery_width = $gallery_class === 'gallery_fancybox_view' ? 640 : parent_width;
                    gallery_height = $gallery_class === 'gallery_fancybox_view' ? 433 : parent_height;
                    // added possibility to override the width and height of the gallery by passing in
                    // a width and/or height to the gallery
                    var gallery_style_attr = $this.attr('style');
                    if (gallery_style_attr){
                        gallery_width = gallery_style_attr.indexOf('width') !== -1 ? $this.width() : gallery_width;
                        gallery_height = gallery_style_attr.indexOf('height') !== -1 ? $this.height() : gallery_height;
                    }

                    var defaults = {
                        panel_width: gallery_width,
                        panel_height: gallery_height,
                        frame_width: 50,
                        frame_height: 50,
                        transition_speed: 350,
                        transition_interval: 10000,
                        zIndex: 90
                    };

                    if ($this.hasClass('js-noFilmstrip')) {
                        defaults.show_filmstrip = false;
                    }
                    var options = $.extend(defaults, opts);
                    var data_options = $this.data('options');
                    if (data_options) {
                        try {
                            data_options = $.parseJSON(data_options);
                            options = $.extend(data_options, options);
                        }
                        catch(e) {
                            var console = window.console || { log: function() {} };
                            console.log('Non Valid JSON passed as');
                        }
                    }

                    $this.galleryView(options);
                });

            };
            $(".galleryViews").eeaGalleryView();
        }

    });

    function showDefinition(context) {
        var $context = $(context);
        if (!$context.hasClass('opened')) {
            $context.closest('.table-definition').find('.table-definition-body').slideDown();
            $context.addClass('opened');
        }
        else {
            $context.closest('.table-definition').find('.table-definition-body').slideUp();
            $context.removeClass('opened');
        }
    }

})(jQuery);

