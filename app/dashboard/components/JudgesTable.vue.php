<template id="judges-table"><div style="display: contents;">
<!-------------------------------------------------------->

    <table class="table sticky-top table-bordered">
        <thead class="bg-white">
            <tr>
                <th style="width: 30%" class="text-center">JUDGES</th>
                <th style="width: 45%" class="text-center">CANDIDATE</th>
                <th style="width: 25%" class="text-center">EVENT</th>
            </tr>
        </thead>

        <tbody class="bg-white">
            <tr
                v-for="([judgeKey, judge], judgeIndex) in Object.entries(processedJudges)"
                :key="judge.id"
                :class="{ 'table-danger': !judge.online, 'help-blink': judge.helpStatus }"
            >
                <td class="text-center" style="height: 115px;">
                    <div style="margin-bottom: 8px;">
                        <h6 class="m-0" style="font-size: 0.9rem;">JUDGE #{{ judge.number }}</h6>
                        <p class="m-0" style="line-height: 1; font-size: 0.9rem; opacity: 0.8; margin-top: 4px !important;">{{ judge.name }}</p>
                    </div>
                    <div class="dropdown d-inline">
                        <p
                            class="dropdown-toggle no-caret m-0 p-0 fw-bold opacity-75"
                            :class="!judge.helpStatus ? `text-${judge.statusClass}` : ''"
                            style="font-size: 0.7rem; cursor: pointer; --bs-dropdown-toggle-icon: none;"
                            data-bs-toggle="dropdown"
                            role="button"
                            aria-expanded="false"
                        >
                            {{ judge.statusText }}
                            <i class="fas fa-fw fa-caret-down" v-if="judge.helpStatus"></i>
                        </p>
                        <ul class="dropdown-menu" v-show="judge.helpStatus">
                            <li>
                                <button class="dropdown-item text-success" @click="$emit('terminate-help', judge.id)">
                                    <small class="fw-bold">
                                        <i class="fas fa-fw fa-check"></i>Done helping JUDGE #{{ judge.number }}
                                    </small>
                                </button>
                            </li>
                        </ul>
                    </div>

                </td>
                <td>
                    <team-block v-if="judge.online && judge.activeTeam" :team="judge.activeTeam"></team-block>
                </td>
                <td class="text-center">
                    <div v-if="judge.online">
                        <p v-if="judge.activeEvent" class="fw-bold opacity-75 text-uppercase m-0" style="font-size: 0.8rem;">
                            {{ judge.activeEvent.title }}
                        </p>
                        <p v-if="judge.activeTeam && judge.activeEvent" class="m-0" style="line-height: 1; margin-top: 8px !important;">
                            <template v-if="judge.activeEvent.criteria[judge.activeColumn]">
                                <span style="font-size: 0.7rem; font-weight: bold; opacity: 0.8">Field #{{ judge.activeColumn + 1 }}</span><br/>
                                <span style="font-size: 0.75rem;">{{ judge.activeEvent.criteria[judge.activeColumn].title }}</span><br/>
                                <span style="font-size: 0.8rem;">{{ judge.activeEvent.criteria[judge.activeColumn].percentage }}%</span>
                            </template>
                            <template v-else-if="judge.activeColumn >= judge.activeEvent.criteria.length">
                                <span style="font-size: 0.7rem; font-weight: bold; opacity: 0.8">Field #{{ judge.activeColumn + 1 }}</span><br/>
                                <span style="font-size: 0.75rem;">TOTAL</span><br/>
                                <span style="font-size: 0.8rem;">{{ judge.activeEvent.criteria_total }}%</span>
                            </template>
                        </p>
                    </div>
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