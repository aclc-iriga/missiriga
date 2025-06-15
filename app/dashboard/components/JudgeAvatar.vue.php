<template id="judge-avatar"><div style="display: contents;">
<!-------------------------------------------------------->

    <span
        class="d-flex justify-content-center align-items-center"
        :class="{ 'help-blink': helpStatus }"
        style="border: 1px solid #555; background-color: #555; color: #fff; border-radius: 100%; width: 26px; height: 26px;"
    >
        <strong class="opacity-75" style="font-size: 1rem;">{{ judge.number }}</strong>
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