<template id="judge-block"><div style="display: contents;">
<!-------------------------------------------------------->

    <p
        class="m-0 p-0 text-center fw-bold opacity-75"
        style="font-size: 0.8rem"
        :style="{ 'color': helpStatus ? 'orangered' : 'inherit' }"
    >
        {{ judge.name }}
    </p>
    <p
        class="m-0 p-0 text-center"
        style="font-size: 0.7rem;"
        :style="{ 'color': helpStatus ? 'orangered' : 'inherit' }"
    >
        Judge #<span class="fw-bold opacity-75">{{ judge.number }}</span>
    </p>

<!-------------------------------------------------------->
</div></template>

<script>
    window.JudgeBlock = {
        /** TEMPLATE */
        template: `#judge-block`,


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