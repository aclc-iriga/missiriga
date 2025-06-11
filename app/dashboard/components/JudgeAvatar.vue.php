<template id="judge-avatar"><div style="display: contents;">
<!-------------------------------------------------------->


    <span
        class="d-flex justify-content-center align-items-center"
        :class="{ 'help-blink': helpStatus }"
        style="border: 1px solid #aaa; border-radius: 100%; width: 25px; height: 25px;"
    >
        <strong class="opacity-75" style="font-size: 0.75rem;">J{{ judge.number }}</strong>
    </span>

<!-------------------------------------------------------->
</div></template>

<script>
    window.JudgeAvatar = {
        /** TEMPLATE */
        template: `#judge-avatar`,


        /** COMPONENTS */
        components: {

        },


        /** PROPS */
        props: {
            judge: {
                type: Object,
                required: true
            },

            helpStatus: {
                type: Boolean,
                default: false
            }
        },


        /** DATA */
        data() {
            return {

            }
        },


        /** COMPUTED */
        computed: {
            
        },


        /** WATCHERS */
        watch: {

        },


        /** METHODS */
        methods: {

        },


        /** CREATED HOOK */
        created() {

        },


        /** MOUNTED HOOK */
        mounted() {
            this.$nextTick(() => {

            });
        },


        /** BEFORE UNMOUNT HOOK*/
        beforeUnmount() {

        }
    };
</script>