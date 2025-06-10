<template id="judges-table"><div style="display: contents;">
<!-------------------------------------------------------->

    <table class="table sticky-top">
        <thead class="bg-white">
            <tr>
                <th style="width: 20%" colspan="2" class="text-center">JUDGES</th>
                <th style="width: 15%" class="text-center">EVENT</th>
                <th style="width: 40%" class="text-center">CANDIDATE</th>
                <th style="width: 35%" class="text-center">CRITERIA</th>
            </tr>
        </thead>

        <tbody class="bg-white">
            <tr
                v-for="([judgeKey, judge], judgeIndex) in Object.entries(processedJudges)"
                :key="judge.id"
                :class="{ 'table-danger': !judge.online, 'help-blink': judge.helpStatus }"
            >
                <td style="height: 150px;" class="text-center" :class="!judge.helpStatus ? `text-${judge.statusClass}` : ''">
                    <h4 class="m-0 p-0">{{ judge.number }}</h4>
                </td>
                <td>
                    <div style="margin-bottom: 5px;">{{ judge.name }}</div>
                    <p class="m-0 p-0 fw-bold opacity-75" :class="!judge.helpStatus ? `text-${judge.statusClass}` : ''" style="font-size: 0.8rem;">{{ judge.statusText }}</p>
                </td>
                <td class="text-center">
                    <span v-if="judge.online && judge.activeEvent" class="fw-bold opacity-75 text-uppercase">
                        {{ judge.activeEvent.title }}
                    </span>
                </td>
                <td>
                    <team-block v-if="judge.online && judge.activeTeam" :team="judge.activeTeam"></team-block>
                </td>
                <td>
                    <template v-if="judge.online && judge.activeTeam && judge.activeEvent">
                        <div v-if="judge.activeEvent.criteria[judge.activeColumn]">
                            <p class="m-0 p-0" style="font-size: 0.8rem;">
                                Field #{{ judge.activeColumn + 1 }}:
                            </p>
                            <p class="m-0 p-0">
                                {{ judge.activeEvent.criteria[judge.activeColumn].title }}
                            </p>
                            <p class="m-0 p-0">
                                {{ judge.activeEvent.criteria[judge.activeColumn].percentage }}%
                            </p>
                        </div>
                        <div v-else-if="judge.activeColumn >= judge.activeEvent.criteria.length">
                            <p class="m-0 p-0" style="font-size: 0.8rem;">
                                Field #{{ judge.activeColumn + 1 }}:
                            </p>
                            <p class="m-0 p-0">
                                TOTAL
                            </p>
                            <p class="m-0 p-0">{{ judge.activeEvent.criteria_total }}%</p>
                        </div>
                    </template>
                </td>
            </tr>
        </tbody>
    </table>

<!-------------------------------------------------------->
</div></template>

<script>
    window.JudgesTable = {
        /** TEMPLATE */
        template: `#judges-table`,


        /** COMPONENTS */
        components: {
            TeamBlock
        },


        /** PROPS */
        props: {
            judges: {
                type: Object,
                required: true
            },

            events: {
                type: Object,
                required: true
            },

            judgesOnline: {
                type: Array,
                required: true
            },

            judgesEvent: {
                type: Object,
                required: true
            },

            judgesTeamColumn: {
                type: Object,
                required: true
            },

            judgesForHelp: {
                type: Array,
                required: true
            },

            teams: {
                type: Object,
                required: true
            }
        },


        /** DATA */
        data() {
            return {

            }
        },


        /** COMPUTED */
        computed: {
            /**
             * @computed processedJudges
             * @description Judge objects with injected data.
             * @returns {Object}
             */
            processedJudges() {
                const judges = { ...this.judges };
                for (const judgeKey in judges) {
                    // judge online status
                    const isOnline  = this.judgesOnline.includes(judgeKey);
                    let statusText  = 'OFFLINE';
                    let statusClass = 'danger';
                    if (isOnline) {
                        statusText  = 'ONLINE';
                        statusClass = 'success';
                    }

                    // judge active event
                    let activeEventKey = '';
                    let activeEvent    = null;
                    if (judgeKey in this.judgesEvent) {
                        activeEventKey = this.judgesEvent[judgeKey] || '';
                    }
                    if (activeEventKey in this.events) {
                        activeEvent = this.events[activeEventKey];
                    }

                    // judge active team and column
                    let activeTeamKey = '';
                    let activeColumn  = 0;
                    let activeTeam    = null;
                    if (judgeKey in this.judgesTeamColumn) {
                        activeTeamKey   = this.judgesTeamColumn[judgeKey].team || '';
                        activeColumn = this.judgesTeamColumn[judgeKey].column  || 0;
                    }
                    if (activeTeamKey in this.teams) {
                        activeTeam = this.teams[activeTeamKey];
                    }

                    // judge help request status
                    const helpStatus = this.judgesForHelp.includes(judgeKey);
                    if (helpStatus) {
                        statusText += ': HELP';
                    }

                    judges[judgeKey] = {
                        ...judges[judgeKey],
                        online        : isOnline,
                        statusText    : statusText,
                        statusClass   : statusClass,
                        activeEventKey: activeEventKey,
                        activeEvent   : activeEvent,
                        activeTeamKey : activeTeamKey,
                        activeTeam    : activeTeam,
                        activeColumn  : activeColumn,
                        helpStatus    : helpStatus
                    }
                }

                return judges;
            }
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